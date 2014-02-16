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
networks = cell(Nnetworks,1);
if(strcmp(channel_model.name,'IBC_CN01_iid'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);
  end
elseif(strcmp(channel_model.name,'hexagonal_CN01_iid_pathloss'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.hexagonal_CN01_iid_pathloss(Kt,Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.wrap_around,channel_model.params.alpha,channel_model.params.beta,Nsim);
  end
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
  end
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
  end
end

% Apply penetration loss
if(~strcmp(channel_model.name,'IBC_CN01_iid'))
  for n = 1:Nnetworks
    for l = 1:Kt
      for k = 1:Kr
        for ii_Nt = 1:Nsim
          networks{n}.channels{k,l}.coefficients(:,:,ii_Nt,:) = sqrt(10^(-channel_model.params.penetration_loss_dB/10))*networks{n}.channels{k,l}.coefficients(:,:,ii_Nt,:);
        end
      end
    end
  end
end


% Impairment parameters for noimp
noimp_imp_params.ms_kappa = 0; noimp_imp_params.bs_kappas = 0;


% Set up storage containers
sumrateSNR_tdma_compensate          = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_tdma_ignore              = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_tdma_noimp               = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);

sumrateSNR_maxrate_compensate       = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxrate_ignore_smart     = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxrate_ignore_oblivious = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxrate_noimp            = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);

sumrateSNR_maxsinr_compensate       = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxsinr_ignore_smart     = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxsinr_ignore_oblivious = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);
sumrateSNR_maxsinr_noimp            = zeros(Kr,length(Pt_dBms),Nsim,Nnetworks);


% Warning if we don't find gurobi!
if(~exist('gurobi','file'))
  warning('Could not find gurobi, will use sedumi.')
end