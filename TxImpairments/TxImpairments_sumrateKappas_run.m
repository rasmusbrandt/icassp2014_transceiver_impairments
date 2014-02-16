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

% Set up powers
Pt = 10^(Pt_dBm/10);
sigma2r = 10^(sigma2r_dBm/10);


parfor ii_Nnetwork = 1:Nnetworks
  ii_Nnetwork
  
  for ii_Nsim = 1:Nsim
    % Temporary results storage, so the outer parfor will work with the
    % nested loops
    iter_sumrateKappas_tdma_compensate          = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_tdma_ignore              = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxrate_compensate       = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxrate_ignore_smart     = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxrate_ignore_oblivious = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxsinr_compensate       = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxsinr_ignore_smart     = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    iter_sumrateKappas_maxsinr_ignore_oblivious = zeros(Kr,length(linear_bs_kappas),length(linear_ms_kappas));
    

    % Get channels
    H = networks{ii_Nnetwork}.as_matrix(ii_Nsim);

    % Perform noimps
    tdma_rate_e = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,noimp_imp_params);
    sumrateKappas_tdma_noimp(:,ii_Nsim,ii_Nnetwork) = tdma_rate_e(:,end);

    MS_oblivious = true;
    maxrate_rate_e = ...
      TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,noimp_imp_params,MS_oblivious);
    sumrateKappas_maxrate_noimp(:,ii_Nsim,ii_Nnetwork) = maxrate_rate_e(:,end);
    maxsinr_rate_e = ...
        TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,noimp_imp_params,weighted_maxsinr,MS_oblivious);
    sumrateKappas_maxsinr_noimp(:,ii_Nsim,ii_Nnetwork) = maxsinr_rate_e(:,end);

    % Loop over BS kappas
    for ii_bs_kappa = 1:length(linear_bs_kappas)
      
      % Linear BS impairments, keep the non-linear impairments that are set in params
      iter_imp_params = imp_params;
      iter_imp_params.bs_kappas(1) = linear_bs_kappas(ii_bs_kappa);

      % Loop (maybe) over MS kappas
      for ii_ms_kappa = 1:length(linear_ms_kappas)

        % Linear MS impairments
        iter_imp_params.ms_kappa = linear_ms_kappas(ii_ms_kappa);


        % =-=-=-=-=-=-=-=-=-=-=
        % TDMA
        % =-=-=-=-=-=-=-=-=-=-=

        if(sim_params.run_tdma)
          tdma_rate_e = TxImpairments_func_TDMA_compensate(H,C,D,Pt,sigma2r,stop_crit,iter_imp_params);
          iter_sumrateKappas_tdma_compensate(:,ii_bs_kappa,ii_ms_kappa) = tdma_rate_e(:,end);

          tdma_rate_e = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,iter_imp_params);
          iter_sumrateKappas_tdma_ignore(:,ii_bs_kappa,ii_ms_kappa) = tdma_rate_e(:,end);
        end


        % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        % MaxRate
        % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

        if(sim_params.run_maxrate)
          maxrate_rate_e = ...
            TxImpairments_func_MaxRate_compensate(H,C,D,Pt,sigma2r,Nd,stop_crit,iter_imp_params);
          iter_sumrateKappas_maxrate_compensate(:,ii_bs_kappa,ii_ms_kappa) = maxrate_rate_e(:,end);

          MS_oblivious = false;
          maxrate_rate_e = ...
            TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,iter_imp_params,MS_oblivious);
          iter_sumrateKappas_maxrate_ignore_smart(:,ii_bs_kappa,ii_ms_kappa) = maxrate_rate_e(:,end);

          MS_oblivious = true;
          maxrate_rate_e = ...
            TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,iter_imp_params,MS_oblivious);
          iter_sumrateKappas_maxrate_ignore_oblivious(:,ii_bs_kappa,ii_ms_kappa) = maxrate_rate_e(:,end);
        end

        % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        % MaxSINR
        % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

        if(sim_params.run_maxsinr)
          maxsinr_rate_e = ...
            TxImpairments_func_WeightedMaxSINR_compensate(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,iter_imp_params,weighted_maxsinr);
          iter_sumrateKappas_maxsinr_compensate(:,ii_bs_kappa,ii_ms_kappa) = maxsinr_rate_e(:,end);

          MS_oblivious = false;
          maxsinr_rate_e = ...
            TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,iter_imp_params,weighted_maxsinr,MS_oblivious);
          iter_sumrateKappas_maxsinr_ignore_smart(:,ii_bs_kappa,ii_ms_kappa) = maxsinr_rate_e(:,end);

          MS_oblivious = true;
          maxsinr_rate_e = ...
            TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,iter_imp_params,weighted_maxsinr,MS_oblivious);
          iter_sumrateKappas_maxsinr_ignore_oblivious(:,ii_bs_kappa,ii_ms_kappa) = maxsinr_rate_e(:,end);
        end
      end
    end
    
    % Store to permanent storage
    sumrateKappas_tdma_compensate(:,:,:,ii_Nsim,ii_Nnetwork)          = iter_sumrateKappas_tdma_compensate;
    sumrateKappas_tdma_ignore(:,:,:,ii_Nsim,ii_Nnetwork)              = iter_sumrateKappas_tdma_ignore;
    sumrateKappas_maxrate_compensate(:,:,:,ii_Nsim,ii_Nnetwork)       = iter_sumrateKappas_maxrate_compensate;
    sumrateKappas_maxrate_ignore_smart(:,:,:,ii_Nsim,ii_Nnetwork)     = iter_sumrateKappas_maxrate_ignore_smart;
    sumrateKappas_maxrate_ignore_oblivious(:,:,:,ii_Nsim,ii_Nnetwork) = iter_sumrateKappas_maxrate_ignore_oblivious;
    sumrateKappas_maxsinr_compensate(:,:,:,ii_Nsim,ii_Nnetwork)       = iter_sumrateKappas_maxsinr_compensate;
    sumrateKappas_maxsinr_ignore_smart(:,:,:,ii_Nsim,ii_Nnetwork)     = iter_sumrateKappas_maxsinr_ignore_smart;
    sumrateKappas_maxsinr_ignore_oblivious(:,:,:,ii_Nsim,ii_Nnetwork) = iter_sumrateKappas_maxsinr_ignore_oblivious;
  end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('TxImpairments_sumrateKappas_run: %s', seconds2human(telapsed)));