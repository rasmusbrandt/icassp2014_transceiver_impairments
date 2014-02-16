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

% Start timing
tstart = tic;

for ii_Nsim = 1:Nsim

  ii_Nsim
  
  % Get channels
  H = network.as_matrix(ii_Nsim);
  
  
  % =-=-=-=-=-=-=-=-=-=-=
  % TDMA
  % =-=-=-=-=-=-=-=-=-=-=
  
  if(sim_params.run_tdma)
    disp('TDMA');
    convergence_tdma_rates_compensate(:,:,ii_Nsim) = TxImpairments_func_TDMA_compensate(H,C,D,Pt,sigma2r,stop_crit,imp_params);
    convergence_tdma_rates_ignore(:,ii_Nsim)       = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,imp_params);
    convergence_tdma_rates_noimp(:,ii_Nsim)        = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,noimp_imp_params);
  end
  
  % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  % MaxRate
  % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  
  if(sim_params.run_maxrate)
    disp('WMMSE');
    [convergence_maxrate_rates_compensate(:,:,ii_Nsim), convergence_maxrate_UWsqrt_compensate(:,:,ii_Nsim), convergence_maxrate_U_compensate(:,:,ii_Nsim),     ...
     convergence_maxrate_W_compensate(:,:,ii_Nsim), convergence_maxrate_V_compensate(:,:,ii_Nsim)] = ...
      TxImpairments_func_MaxRate_compensate(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params);
    
    MS_oblivious = false;
    [convergence_maxrate_rates_ignore_smart(:,:,ii_Nsim), convergence_maxrate_UWsqrt_ignore_smart(:,:,ii_Nsim), convergence_maxrate_U_ignore_smart(:,:,ii_Nsim),     ...
     convergence_maxrate_W_ignore_smart(:,:,ii_Nsim), convergence_maxrate_V_ignore_smart(:,:,ii_Nsim)] = ...
      TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,MS_oblivious);
    
    MS_oblivious = true;
    [convergence_maxrate_rates_ignore_oblivious(:,:,ii_Nsim), convergence_maxrate_UWsqrt_ignore_oblivious(:,:,ii_Nsim), convergence_maxrate_U_ignore_oblivious(:,:,ii_Nsim),     ...
     convergence_maxrate_W_ignore_oblivious(:,:,ii_Nsim), convergence_maxrate_V_ignore_oblivious(:,:,ii_Nsim)] = ...
      TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,MS_oblivious);
    
    MS_oblivious = true;
    [convergence_maxrate_rates_noimp(:,:,ii_Nsim), convergence_maxrate_UWsqrt_noimp(:,:,ii_Nsim), convergence_maxrate_U_noimp(:,:,ii_Nsim),     ...
     convergence_maxrate_W_noimp(:,:,ii_Nsim), convergence_maxrate_V_noimp(:,:,ii_Nsim)] = ...
      TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,noimp_imp_params,MS_oblivious);
  end
  
  % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  % MaxSINR
  % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  
  if(sim_params.run_maxsinr)
    disp('MaxSINR');
    convergence_maxsinr_rates_compensate(:,:,ii_Nsim)       = TxImpairments_func_WeightedMaxSINR_compensate(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr);
    
    MS_oblivious = false;
    convergence_maxsinr_rates_ignore_smart(:,:,ii_Nsim)     = TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr,MS_oblivious);
    
    MS_oblivious = true;
    convergence_maxsinr_rates_ignore_oblivious(:,:,ii_Nsim) = TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr,MS_oblivious);
    
    MS_oblivious = true;
    convergence_maxsinr_rates_noimp(:,:,ii_Nsim)            = TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,noimp_imp_params,weighted_maxsinr,MS_oblivious);
  end
end

% Report timing performance
disp(sprintf('TxImpairments_convergence_run: %s', seconds2human(toc(tstart))));