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
  TxImpairments_func_TDMA_compensate(H,C,D,Pt,sigma2r,stop_crit,imp_params)
  
  % Semi-fixed algorithm parameters
  MAX_ITERS = 5e2;
  FORCE_YALMIP = false;

  % Parameters
  [Mr,Mt,Kr,Kt,~,~] = size(H);
  Kc = Kr/Kt;
  Nd = min(Mr,Mt);

  % Filter variables
  U = zeros(Mr,Nd,Kr);    % receive filters
  W = zeros(Nd,Nd,Kr);    % MMSE weights
  V = zeros(Mt,Nd,Kr);
  for l = 1:Kt
    Dl = find(D(:,l) == 1)';

    for k = Dl
      [~,~,Vp] = svd(H(:,:,k,l));
      V(:,:,k) = sqrt(Pt*Kt/Kc)*(Vp(:,1:Nd)/norm(Vp(:,1:Nd),'fro')); % Factor Kt since each BS only transmit 1/Kt of the time, and has Kc users
    end
  end
  
  % Performance evolution variables
  if(stop_crit < 1), stop_crit_storage = MAX_ITERS; else, stop_crit_storage = stop_crit; end;
  user_rates_e   = zeros(Kr,stop_crit_storage); % Sum rate evolution
  UWsqrt_e = zeros(Kr,stop_crit_storage); % ||UW^(1/2)||^2 evolution
  U_e      = zeros(Kr,stop_crit_storage); % ||U||^2 evolution
  W_e      = zeros(Kr,stop_crit_storage); % tr(W) evolution
  V_e      = zeros(Kr,stop_crit_storage); % ||V||^2 evolution

  % Do we need to use Yalmip?
  if(length(imp_params.bs_kappas) == 1)
    linear_BS_impairments = true;
  else
    linear_BS_impairments = false;
  end
  
  % Get solver if needed
  if(FORCE_YALMIP || ~linear_BS_impairments)
    solver = TxImpairments_func_build_yalmip_solver(Mt,Nd,1,Pt*Kt/Kc,imp_params);
  end

  % Iterate
  iter = 1;
  while (iter <= MAX_ITERS)
    
    % Receiver side optimization
    for k = 1:Kr
      dinvk = find(D(k,:) == 1);

      % Receiver side information
      [~,F,Qtdma] = TxImpairments_func_Q_F(H,V,C,D,sigma2r,imp_params);
      
      % Only update if this MS is served
      if(dinvk)
        % New receive filter
        U(:,:,k) = Qtdma(:,:,k)\F(:,:,k);
        
        % Get new MMSE weights
        W(:,:,k) = (eye(Nd) - U(:,:,k)'*F(:,:,k))\eye(Nd);
        W(:,:,k) = (W(:,:,k) + W(:,:,k)')/2;
      end
    end
    
    % Transmitter side optimization
    if(FORCE_YALMIP || ~linear_BS_impairments)
      for l = 1:Kt
        Dl = find(D(:,l) == 1)';
        for k = Dl
          % Set up in data to optimization, and solve
          Wsqrtm_in = sqrtm(W(:,:,k));
          G_in = H(:,:,k,l)'*U(:,:,k)*Wsqrtm_in;
          T_in = G_in*G_in';
          T_diag_UWUh = H(:,:,k,l)'*(diag(diag(U(:,:,k)*W(:,:,k)*U(:,:,k)')))*H(:,:,k,l);
          Tdiag_sqrt_in = diag(sqrt(diag(T_in))); [Tsqrtm_in,~] = sqrtm(T_in); Tsqrtm_inv_in = pinv(Tsqrtm_in); [T_diag_UWUh_sqrtm_in,~] = sqrtm(T_diag_UWUh);
          
          % Undocumented trick from Johan L?fberg: store solver between iterations
          [Vs,~,~,~,solver] = solver{{Tdiag_sqrt_in,Tsqrtm_in,Tsqrtm_inv_in,T_diag_UWUh_sqrtm_in,Wsqrtm_in,G_in}};

          % Get solution
          V(:,:,k) = double(Vs);
        end
      end
    else
      V = TxImpairments_func_TDMA_compensate_BSOpt_bisection_lin_imps(H,U,W,D,Pt,sigma2r,imp_params);
    end
    
    % Calculate evolution measures
    user_rates_e(:,iter) = TxImpairments_func_tdma_rate(H,V,D,sigma2r,imp_params);
    
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