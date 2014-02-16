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

parfor ii_Nnetwork = 1:Nnetworks
  ii_Nnetwork
  
  for ii_Nsim = 1:Nsim
    % Temporary results storage, so the outer parfor will work with the nested loops
    iter_sumrateSNR_tdma_compensate          = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_tdma_ignore              = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_tdma_noimp               = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxrate_compensate       = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxrate_ignore_smart     = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxrate_ignore_oblivious = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxrate_noimp            = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxsinr_compensate       = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxsinr_ignore_smart     = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxsinr_ignore_oblivious = zeros(Kr,length(Pt_dBms));
    iter_sumrateSNR_maxsinr_noimp            = zeros(Kr,length(Pt_dBms));


    % Get channels
    H = networks{ii_Nnetwork}.as_matrix(ii_Nsim);


    % Loop over downlink SNRs
    for ii_SNR = 1:length(Pt_dBms)

      % Set up powers
      Pt = 10^(Pt_dBms(ii_SNR)/10); sigma2r = 10^(sigma2r_dBm/10);


      % =-=-=-=-=-=-=-=-=-=-=
      % TDMA
      % =-=-=-=-=-=-=-=-=-=-=

      if(sim_params.run_tdma)
        tdma_rate_e = TxImpairments_func_TDMA_compensate(H,C,D,Pt,sigma2r,stop_crit,imp_params);
        iter_sumrateSNR_tdma_compensate(:,ii_SNR) = tdma_rate_e(:,end);

        tdma_rate_e = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,imp_params);
        iter_sumrateSNR_tdma_ignore(:,ii_SNR) = tdma_rate_e(:,end);

        tdma_rate_e = TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,noimp_imp_params);
        iter_sumrateSNR_tdma_noimp(:,ii_SNR) = tdma_rate_e(:,end);
      end


      % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      % MaxRate
      % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

      if(sim_params.run_maxrate)
        maxrate_rate_e = ...
          TxImpairments_func_MaxRate_compensate(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params);
        iter_sumrateSNR_maxrate_compensate(:,ii_SNR) = maxrate_rate_e(:,end);

        MS_oblivious = false;
        maxrate_rate_e = ...
          TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,MS_oblivious);
        iter_sumrateSNR_maxrate_ignore_smart(:,ii_SNR) = maxrate_rate_e(:,end);

        MS_oblivious = true;
        maxrate_rate_e = ...
          TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,imp_params,MS_oblivious);
        iter_sumrateSNR_maxrate_ignore_oblivious(:,ii_SNR) = maxrate_rate_e(:,end);

        MS_oblivious = true;
        maxrate_rate_e = ...
          TxImpairments_func_MaxRate_ignore(H,C,D,Pt,sigma2r,Nd,stop_crit,noimp_imp_params,MS_oblivious);
        iter_sumrateSNR_maxrate_noimp(:,ii_SNR) = maxrate_rate_e(:,end);
      end

      % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      % MaxSINR
      % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

      if(sim_params.run_maxsinr)
        maxsinr_rate_e = ...
          TxImpairments_func_WeightedMaxSINR_compensate(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr);
        iter_sumrateSNR_maxsinr_compensate(:,ii_SNR) = maxsinr_rate_e(:,end);

        MS_oblivious = false;
        maxsinr_rate_e = ...
          TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr,MS_oblivious);
        iter_sumrateSNR_maxsinr_ignore_smart(:,ii_SNR) = maxsinr_rate_e(:,end);

        MS_oblivious = true;
        maxsinr_rate_e = ...
          TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,imp_params,weighted_maxsinr,MS_oblivious);
        iter_sumrateSNR_maxsinr_ignore_oblivious(:,ii_SNR) = maxsinr_rate_e(:,end);

        MS_oblivious = true;
        maxsinr_rate_e = ...
          TxImpairments_func_WeightedMaxSINR_ignore(H,C,Dmaxsinr,Pt,sigma2r,Nd_maxsinr,stop_crit,noimp_imp_params,weighted_maxsinr,MS_oblivious);
        iter_sumrateSNR_maxsinr_noimp(:,ii_SNR) = maxsinr_rate_e(:,end);
      end

    end


    % Store to permanent storage
    sumrateSNR_tdma_compensate(:,:,ii_Nsim,ii_Nnetwork)          = iter_sumrateSNR_tdma_compensate;
    sumrateSNR_tdma_ignore(:,:,ii_Nsim,ii_Nnetwork)              = iter_sumrateSNR_tdma_ignore;
    sumrateSNR_tdma_noimp(:,:,ii_Nsim,ii_Nnetwork)               = iter_sumrateSNR_tdma_noimp;
    sumrateSNR_maxrate_compensate(:,:,ii_Nsim,ii_Nnetwork)       = iter_sumrateSNR_maxrate_compensate;
    sumrateSNR_maxrate_ignore_smart(:,:,ii_Nsim,ii_Nnetwork)     = iter_sumrateSNR_maxrate_ignore_smart;
    sumrateSNR_maxrate_ignore_oblivious(:,:,ii_Nsim,ii_Nnetwork) = iter_sumrateSNR_maxrate_ignore_oblivious;
    sumrateSNR_maxrate_noimp(:,:,ii_Nsim,ii_Nnetwork)            = iter_sumrateSNR_maxrate_noimp;
    sumrateSNR_maxsinr_compensate(:,:,ii_Nsim,ii_Nnetwork)       = iter_sumrateSNR_maxsinr_compensate;
    sumrateSNR_maxsinr_ignore_smart(:,:,ii_Nsim,ii_Nnetwork)     = iter_sumrateSNR_maxsinr_ignore_smart;
    sumrateSNR_maxsinr_ignore_oblivious(:,:,ii_Nsim,ii_Nnetwork) = iter_sumrateSNR_maxsinr_ignore_oblivious;
    sumrateSNR_maxsinr_noimp(:,:,ii_Nsim,ii_Nnetwork)            = iter_sumrateSNR_maxsinr_noimp;
  end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('TxImpairments_sumrateSNR_run: %s', seconds2human(telapsed)));