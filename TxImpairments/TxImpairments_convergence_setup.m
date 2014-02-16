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

% Generate network
if(strcmp(channel_model.name,'IBC_CN01_iid'))
  network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);
elseif(strcmp(channel_model.name,'hexagonal_CN01_iid_pathloss'))
  network = multicellsim.SyntheticNetworkFactory.hexagonal_CN01_iid_pathloss(Kt,Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.wrap_around,channel_model.params.alpha,channel_model.params.beta,Nsim);
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss'))
  network = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern'))
  network = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
end

% Apply penetration loss
if(~strcmp(channel_model.name,'IBC_CN01_iid'))
  for l = 1:Kt
    for k = 1:Kr
      for ii_Nt = 1:Nsim
        network.channels{k,l}.coefficients(:,:,ii_Nt,:) = sqrt(10^(-channel_model.params.penetration_loss_dB/10))*network.channels{k,l}.coefficients(:,:,ii_Nt,:);
      end
    end
  end
end


% Convert powers into linear scale
Pt = 10^(Pt_dBm/10); sigma2r = 10^(sigma2r_dBm/10);

% Impairment parameters for noimp
noimp_imp_params.ms_kappa = 0; noimp_imp_params.bs_kappas = 0;


% Set up storage containers
convergence_tdma_rates_compensate           = zeros(Kr,stop_crit,Nsim);
convergence_tdma_rates_ignore               = zeros(Kr,Nsim);
convergence_tdma_rates_noimp                = zeros(Kr,Nsim);

convergence_maxrate_rates_compensate        = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_UWsqrt_compensate       = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_U_compensate            = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_W_compensate            = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_V_compensate            = zeros(Kr,stop_crit,Nsim);

convergence_maxrate_rates_ignore_oblivious  = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_UWsqrt_ignore_oblivious = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_U_ignore_oblivious      = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_W_ignore_oblivious      = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_V_ignore_oblivious      = zeros(Kr,stop_crit,Nsim);

convergence_maxrate_rates_ignore_smart      = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_UWsqrt_ignore_smart     = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_U_ignore_smart          = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_W_ignore_smart          = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_V_ignore_smart          = zeros(Kr,stop_crit,Nsim);

convergence_maxrate_rates_noimp             = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_UWsqrt_noimp            = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_U_noimp                 = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_W_noimp                 = zeros(Kr,stop_crit,Nsim);
convergence_maxrate_V_noimp                 = zeros(Kr,stop_crit,Nsim);

convergence_maxsinr_rates_compensate        = zeros(Kr,stop_crit,Nsim);
convergence_maxsinr_rates_ignore_smart      = zeros(Kr,stop_crit,Nsim);
convergence_maxsinr_rates_ignore_oblivious  = zeros(Kr,stop_crit,Nsim);
convergence_maxsinr_rates_noimp             = zeros(Kr,stop_crit,Nsim);


% Warning if we don't find gurobi!
if(~exist('gurobi','file'))
  warning('Could not find gurobi, will use sedumi.')
end