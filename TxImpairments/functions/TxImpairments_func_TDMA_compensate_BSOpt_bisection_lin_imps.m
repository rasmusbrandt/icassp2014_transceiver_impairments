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

function [V,mu_e] = TxImpairments_func_TDMA_compensate_BSOpt_bisection_lin_imps(H,U,W,D,Pt,sigma2r,imp_params)
  T_INV_RCOND         = 1e-14; % invertibility criterion
  BIS_TOL             = 1e-3;  % bisection tolerance
  BIS_MAX_ITERS       = 1e2;   % max number of bisection iterations
  
  % Check that it is linear
  if(length(imp_params.bs_kappas) ~= 1)
    error('Not linear nu!');
  end
  
  % Parameters
  [~,Mt,Kr,Kt,~,~] = size(H); Kc = Kr/Kt;
  [Nd,~] = size(W); 
  V = zeros(Mt,Nd,Kr);
  mu_e = zeros(Kr,1);
  
  % Effective power constraint
  Pt_eff = (Pt*Kt/Kc)/(1 + (imp_params.bs_kappas(1))^2);
  
  % Find precoders for all users
  for l = 1:Kt

    % Only update precoders if this BS serves any MS at all
    if(any(D(:,l)))
      
      % MSs served by this BS
      Dl = find(D(:,l) == 1)';

      for k = Dl
        UWUh = U(:,:,k)*W(:,:,k)*U(:,:,k)'; UWUh = (UWUh + UWUh')/2;
        Ttdma = H(:,:,k,l)'*UWUh*H(:,:,k,l); Ttdma_diag = diag(diag(Ttdma));
        Ttdma_diag_UWUh = H(:,:,k,l)'*diag(diag(UWUh))*H(:,:,k,l);
    
        % Form matrices and function needed for bisection
        bis_M = H(:,:,k,l)'*(U(:,:,k)*(W(:,:,k)*W(:,:,k))*U(:,:,k)')*H(:,:,k,l);
        [bis_J,bis_PI] = eig(Ttdma + (imp_params.bs_kappas(1)^2)*Ttdma_diag + (imp_params.ms_kappa^2)*Ttdma_diag_UWUh);
        bis_PI_diag = abs(diag(bis_PI));
        bis_JMJ_diag = abs(diag(bis_J'*bis_M*bis_J)); % abs to remove imaginary noise
        f = @(mu) sum(bis_JMJ_diag./(bis_PI_diag + mu).^2);


        % Bisection lower bound
        mu_lower = 0;


        % Do we need to do bisection?
        if(rcond(Ttdma + (imp_params.bs_kappas(1)^2)*Ttdma_diag + (imp_params.ms_kappa^2)*Ttdma_diag_UWUh) > T_INV_RCOND && f(mu_lower) < Pt_eff)
          % No bisection needed
          mu_star = mu_lower;
        else
          % Upper bound, should be feasible
          mu_upper = sqrt((Mt/Pt_eff)*max(bis_JMJ_diag)) - min(bis_PI_diag);
          if(f(mu_upper) > Pt_eff)
            error('Infeasible upper bound.');
          end

          bis_iters = 1;
          while(bis_iters <= BIS_MAX_ITERS)
            mu = (1/2)*(mu_lower + mu_upper);

            if(f(mu) < Pt_eff)
              % New point was feasible, replace upper point
              conv_crit = abs(mu - mu_upper)/abs(mu_upper);
              mu_upper = mu;
            else
              % New point was not feasible, replace lower point
              conv_crit = abs(mu - mu_lower)/abs(mu_lower);
              mu_lower = mu;
            end

            % Convergence check
            if ((conv_crit < BIS_TOL) || bis_iters == BIS_MAX_ITERS)
              mu_star = mu_upper; % Use the upper point, so we know it is feasible
              break;
            end

            bis_iters = bis_iters + 1;
          end

          if(bis_iters == BIS_MAX_ITERS)
            warning('Bisection reached max iterations.');
          end
        end

        % Find precoders
        V(:,:,k) = (Ttdma + (imp_params.bs_kappas(1)^2)*Ttdma_diag + (imp_params.ms_kappa^2)*Ttdma_diag_UWUh + mu_star*eye(Mt))\(H(:,:,k,l)'*U(:,:,k)*W(:,:,k));

        % Store Lagrange multiplier
        mu_e(k) = mu_star;
      end

    end % if(any(D(:,l)))
  end % loop over transmitters
end