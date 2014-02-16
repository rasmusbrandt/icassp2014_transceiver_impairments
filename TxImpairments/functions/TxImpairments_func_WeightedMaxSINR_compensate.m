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

function user_rates_e = ...
  TxImpairments_func_WeightedMaxSINR_compensate(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,weighted_maxsinr)
  
  % Constants
  MAX_ITERS = 5e2;

  % Parameters
  [Mr,Mt,Kr,Kt,~,~] = size(H);

  % Filter variables
  U = zeros(Mr,Nd,Kr); % receive filters
  W = zeros(Nd,Nd,Kr); % weights
  V = zeros(Mt,Nd,Kr); % transmit filters
  for l = 1:Kt
    Dl = find(D(:,l) == 1)';
    Kc = length(Dl);

    for k = Dl
      Vp = fft(eye(Mt,Nd))/sqrt(Mt);
      V(:,:,k) = sqrt(Pt/Kc)*(Vp/norm(Vp,'fro'));
    end
  end
  
  % Performance evolution variables
  if(stop_crit < 1), stop_crit_storage = MAX_ITERS; else, stop_crit_storage = stop_crit; end;
  user_rates_e   = zeros(Kr,stop_crit_storage); % Sum rate evolution
  
  % Identity weights
  Wident = zeros(Nd,Nd,Kr);
  for k = 1:Kr
    Wident(:,:,k) = eye(Nd);
  end
  
  
  % Iterate
  iter = 1;
  while (iter <= MAX_ITERS)
    
    % Receiver side information
    [Q,F] = TxImpairments_func_Q_F(H,V,C,D,sigma2r,imp_params);
    
    % Find receive filters for all MS k
    for k = 1:Kr
      % BS this MS receives data from
      dinvk = find(D(k,:) == 1);

      % Only update if this MS is served
      if(dinvk)
        
        % Weights (like in WMMSE)
        W(:,:,k) = eye(Nd) + F(:,:,k)'*((Q(:,:,k) - (F(:,:,k)*F(:,:,k)'))\F(:,:,k));
        W(:,:,k) = (W(:,:,k) + W(:,:,k)')/2;
        
        % Loop over all streams
        for n = 1:Nd
          % Build interference plus noise covariance matrix, for this stream
          Bs = Q(:,:,k) - (F(:,n,k)*F(:,n,k)');

          % Update receive filters
          Utmp = Bs\F(:,n,k);
          U(:,n,k) = Utmp/norm(Utmp,2);
        end
        if(weighted_maxsinr)
          U(:,:,k) = U(:,:,k)*sqrtm(W(:,:,k));
        end
        U(:,:,k) = sqrt(Pt)*U(:,:,k)/norm(U(:,:,k),'fro');
      end
    end

    
    % Transmitter side information
    [T,G,T_diag_UWUh] = TxImpairments_func_T_G(H,U,Wident,C,D);
    
    
    % Find precoders for all BS l serving users Dl
    for l = 1:Kt
      % MSs this BS serve
      Dl = find(D(:,l) == 1)'; Kc = length(Dl);
      
      % Only update precoder if this BS is transmitting to any user at all
      if(Kc > 0)

        for k = Dl
          % Loop over all streams (N.B., the number of streams is defined
          % from the MS perspective)
          for n = 1:Nd
            % Build interference plus noise covariance matrix, for this stream
            Brs = T(:,:,l) - (G(:,n,k)*G(:,n,k)') + sigma2r*eye(Mt) + (imp_params.bs_kappas(1)^2)*diag(diag(T(:,:,l))) + (imp_params.ms_kappa^2)*T_diag_UWUh(:,:,l);

            % Update virtual receive filters (uniform power allocation over users and streams)
            Vtmp = Brs\G(:,n,k);
            V(:,n,k) = Vtmp/norm(Vtmp,2); % power added below
          end
          if(weighted_maxsinr)
            V(:,:,k) = V(:,:,k)*sqrtm(W(:,:,k));
          end
          V(:,:,k) = sqrt(Pt/(Kc*(1 + imp_params.bs_kappas(1)^2)))*V(:,:,k)/norm(V(:,:,k),'fro');
        end
      end

    end % loop over transmitters

    % Calculate evolution measures
    user_rates_e(:,iter) = TxImpairments_func_sdma_rate(H,V,D,sigma2r,imp_params);
    
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