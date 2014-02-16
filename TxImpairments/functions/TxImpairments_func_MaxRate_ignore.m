% icassp2014_TxImpairments
% Copyright (C) 2014, Rasmus Brandt

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

function [user_rates_e,UWsqrt_e,U_e,W_e,V_e] = ...
  TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,MS_oblivious)
  
  
  % Semi-fixed algorithm parameters
  MAX_ITERS = 5e2;
  

  % Parameters
  [Mr,Mt,Kr,Kt,~,~] = size(H);
  Kc = Kr/Kt;

  % Filter variables
  U = zeros(Mr,Nd,Kr);    % receive filters
  W = zeros(Nd,Nd,Kr);    % MMSE weights
  V = zeros(Mt,Nd,Kr);
  for l = 1:Kt
    Dl = find(D(:,l) == 1)';

    for k = Dl
      Vp = fft(eye(Mt,Nd))/sqrt(Mt);
      V(:,:,k) = sqrt(Pt/Kc)*(Vp/norm(Vp,'fro'));
    end
  end
  
  % Performance evolution variables
  if(stop_crit < 1), stop_crit_storage = MAX_ITERS; else, stop_crit_storage = stop_crit; end;
  user_rates_e   = zeros(Kr,stop_crit_storage); % Sum rate evolution
  UWsqrt_e = zeros(Kr,stop_crit_storage); % ||UW^(1/2)||^2 evolution
  U_e      = zeros(Kr,stop_crit_storage); % ||U||^2 evolution
  W_e      = zeros(Kr,stop_crit_storage); % tr(W) evolution
  V_e      = zeros(Kr,stop_crit_storage); % ||V||^2 evolution


  % Iterate
  iter = 1;
  while (iter <= MAX_ITERS)
    
    % Receiver side information
    [Q,F,~,Qoblivious] = TxImpairments_func_Q_F(H,V,C,D,sigma2r,imp_params);
    
    % Is the MS oblivious of the impairments or not?
    if(MS_oblivious)
      Quse = Qoblivious;
    else
      Quse = Q;
    end
    
    % Receiver side optimization
    for k = 1:Kr
      dinvk = find(D(k,:) == 1);
      
      % Only update if this MS is served
      if(dinvk)
        
        % New receive filter
        U(:,:,k) = Quse(:,:,k)\F(:,:,k);
        
        % Get new MMSE weights
        W(:,:,k) = (eye(Nd) - U(:,:,k)'*F(:,:,k))\eye(Nd);
        W(:,:,k) = (W(:,:,k) + W(:,:,k)')/2;
      end
    end
    

    % Transmitter side optimization
    V = TxImpairments_func_MaxRate_ignore_BSOpt_bisection(H,U,W,C,D,Pt);
    
    
    % Calculate evolution measures
    user_rates_e(:,iter) = TxImpairments_func_sdma_rate(H,V,D,sigma2r,imp_params);
    for k = 1:Kr
      UWsqrt_e(k,iter) = norm(U(:,:,k)*sqrtm(W(:,:,k)),'fro')^2;
      U_e(k,iter)      = norm(U(:,:,k),'fro')^2;
      W_e(k,iter)      = abs(trace(W(:,:,k))); % abs to remove insignificant imaginary part
      V_e(k,iter)      = norm(V(:,:,k),'fro')^2;
    end

    % Convergence checks
    if(iter >= MAX_ITERS)
      break;
    end
    if((stop_crit > 1) && iter >= stop_crit)
      break;
    elseif((stop_crit < 1) && iter >= 2)
      obj_cur = sum(user_rates_e(:,iter)); obj_prev = sum(user_rates_e(:,iter-1));
      if(abs(obj_cur - obj_prev)/abs(obj_cur) < stop_crit)
        break;
      end
    end

    iter = iter + 1;

  end % outer iterations

  user_rates_e = user_rates_e(:,1:iter);
end