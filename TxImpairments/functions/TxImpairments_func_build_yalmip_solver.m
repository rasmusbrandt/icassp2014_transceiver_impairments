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

function solver = TxImpairments_func_build_yalmip_solver(Mt,Nd,Kc_simul,Pt_simul,imp_params)

  % Input data
  Tdiag_sqrt_in = sdpvar(Mt,Mt);
  Tsqrtm_in = sdpvar(Mt,Mt,'full','complex');
  Tsqrtm_inv_in = sdpvar(Mt,Mt,'full','complex');
  T_diag_UWUh_sqrtm_in = sdpvar(Mt,Mt,'full','complex');
  Wsqrtm_in = sdpvar(Nd,Nd,Kc_simul,'full','complex');
  G_in = sdpvar(Mt,Nd,Kc_simul,'full','complex');


  % Optimization variable
  Vs = sdpvar(Mt,Kc_simul*Nd,'full','complex');


  % Receiver impairments
  t_rx_imp = sdpvar(1); e_rx_imp = sdpvar(Mt,Kc_simul*Nd,'full','complex');
  objective = (imp_params.ms_kappa^2)*t_rx_imp^2;
  constraints = [e_rx_imp == T_diag_UWUh_sqrtm_in*Vs] + cone(e_rx_imp(:),t_rx_imp);


  % Transmitter impairments
  s_tx_imp = sdpvar(Mt,1);
  t_tx_imp = sdpvar(1); e_tx_imp = sdpvar(Mt,1);
  objective = objective + t_tx_imp^2;
  constraints = constraints + ...
    [e_tx_imp == Tdiag_sqrt_in*s_tx_imp] + cone(e_tx_imp,t_tx_imp);

  switch length(imp_params.bs_kappas)
    case 1
      for m = 1:Mt
        constraints = constraints + ...
          [s_tx_imp(m) >= imp_params.bs_kappas(1)*norm(Vs(m,:),'fro')];
      end

    case 2
      for m = 1:Mt
        constraints = constraints + ...
          [s_tx_imp(m) >= imp_params.bs_kappas(1)*norm(Vs(m,:),'fro') + (imp_params.bs_kappas(1)*imp_params.bs_kappas(2))*cpower(norm(Vs(m,:)/imp_params.bs_kappas(2),'fro'),3)];
      end

    case 3
      if(imp_params.bs_kappas(2) == Inf)
        for m = 1:Mt
          constraints = constraints + ...
            [s_tx_imp(m) >= imp_params.bs_kappas(1)*norm(Vs(m,:),'fro') + (imp_params.bs_kappas(1)*imp_params.bs_kappas(3))*cpower(norm(Vs(m,:)/imp_params.bs_kappas(3),'fro'),5)];
        end
      else
        for m = 1:Mt
          constraints = constraints + ...
            [s_tx_imp(m) >= imp_params.bs_kappas(1)*norm(Vs(m,:),'fro') + (imp_params.bs_kappas(1)*imp_params.bs_kappas(2))*cpower(norm(Vs(m,:)/imp_params.bs_kappas(2),'fro'),3) + (imp_params.bs_kappas(1)*imp_params.bs_kappas(3))*cpower(norm(Vs(m,:)/imp_params.bs_kappas(3),'fro'),5)];
        end
      end
  end


  % Per-user terms
  t_users = sdpvar(Kc_simul,1); e_users = sdpvar(Mt,Nd,Kc_simul,'full','complex');
  for k = 1:Kc_simul
    objective = objective + t_users(k)^2;
    constraints = constraints + ...
      [e_users(:,:,k) == Tsqrtm_in*Vs(:,(k-1)*Nd+1:k*Nd) - Tsqrtm_inv_in*G_in(:,:,k)*Wsqrtm_in(:,:,k)] + cone(reshape(e_users(:,:,k),Mt*Nd,1),t_users(k));
  end
  
  
  % Power constraint
  constraints = constraints + cone(reshape([Vs s_tx_imp],Mt*(Kc_simul*Nd + 1),1),sqrt(Pt_simul));


  % Set up solver
  if(exist('gurobi','file'))
    options = sdpsettings('solver','gurobi','verbose',0,'cachesolvers',1);
  else
    options = sdpsettings('solver','sedumi','verbose',0,'cachesolvers',1);
  end
  solver = optimizer(constraints,objective,options,{Tdiag_sqrt_in,Tsqrtm_in,Tsqrtm_inv_in,T_diag_UWUh_sqrtm_in,Wsqrtm_in,G_in},Vs);
end