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

function [V,mu_e] = TxImpairments_func_MaxRate_compensate_BSOpt_bisection_lin_imps(H,U,W,C,D,Pt,sigma2r,imp_params)
  T_INV_RCOND         = 1e-14; % invertibility criterion
  BIS_TOL             = 1e-3;  % bisection tolerance
  BIS_MAX_ITERS       = 1e2;   % max number of bisection iterations
  
  % Check that it is linear
  if(length(imp_params.bs_kappas) ~= 1)
    error('Not linear nu!');
  end
  
  % Parameters
  [~,Mt,Kr,Kt,~,~] = size(H);
  [Nd,~] = size(W); 
  V = zeros(Mt,Nd,Kr);
  mu_e = zeros(Kt,1);
  
  % Transmitter side information
  [T,G,T_diag_UWUh] = TxImpairments_func_T_G(H,U,W,C,D);
  
  % Effective power constraint
  Pt_eff = Pt/(1 + (imp_params.bs_kappas(1))^2);
  
  % Find precoders for all BS l serving users Dl
  for l = 1:Kt

    % Only update precoders if this BS serves any MS at all
    if(any(D(:,l)))
      
      % MSs served by this BS
      Dl = find(D(:,l) == 1)';

      % Form matrices and function needed for bisection
      bis_M = zeros(Mt,Mt);
      for k = Dl
        bis_M = bis_M + G(:,:,k)*W(:,:,k)*G(:,:,k)';
      end
      [bis_J,bis_PI] = eig(T(:,:,l) + (imp_params.bs_kappas(1)^2)*diag(diag(T(:,:,l))) + (imp_params.ms_kappa^2)*T_diag_UWUh(:,:,l));
      bis_PI_diag = abs(diag(bis_PI));
      bis_JMJ_diag = abs(diag(bis_J'*bis_M*bis_J)); % abs to remove imaginary noise
      f = @(mu) sum(bis_JMJ_diag./(bis_PI_diag + mu).^2);


      % Bisection lower bound
      mu_lower = 0;
        

      % Do we need to do bisection?
      if(rcond((T(:,:,l) + (imp_params.bs_kappas(1)^2)*diag(diag(T(:,:,l))) + (imp_params.ms_kappa^2)*T_diag_UWUh(:,:,l))) > T_INV_RCOND && f(mu_lower) < Pt_eff)
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
      for k = Dl
        V(:,:,k) = (T(:,:,l) + (imp_params.bs_kappas(1)^2)*diag(diag(T(:,:,l))) + (imp_params.ms_kappa^2)*T_diag_UWUh(:,:,l) + mu_star*eye(Mt))\(G(:,:,k)*sqrtm(W(:,:,k)));
      end

      % Store Lagrange multiplier
      mu_e(l) = mu_star;

    end % if(any(D(:,l)))
  end % loop over transmitters
end