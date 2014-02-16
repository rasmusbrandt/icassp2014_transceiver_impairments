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

if(loop_bs)
  figure; hold on;

  y = sum(bs_param1_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');

  y = sum(bs_param2_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');

  y = sum(bs_param3_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');


  y = sum(bs_param1_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');

  y = sum(bs_param2_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');

  y = sum(bs_param3_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');


  y = sum(bs_param1_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');

  y = sum(bs_param2_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');

  y = sum(bs_param3_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');


  y = sum(bs_param1_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');

  y = sum(bs_param2_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');

  y = sum(bs_param3_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');


  y = sum(bs_param1_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');

  y = sum(bs_param2_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');

  y = sum(bs_param3_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');


  y = sum(bs_param1_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');

  y = sum(bs_param2_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');

  y = sum(bs_param3_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');


  y = sum(bs_param2_sumrateKappas_tdma_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k-');

  y = sum(bs_param3_sumrateKappas_tdma_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k-');


  y = sum(bs_param2_sumrateKappas_tdma_ignore,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k:');

  y = sum(bs_param3_sumrateKappas_tdma_ignore,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k:');


  xlabel('Linear BS kappas'); ylabel('Sum rate');
end


if(loop_ms)
  figure; hold on;

  y = sum(ms_param1_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');

  y = sum(ms_param2_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');

  y = sum(ms_param3_sumrateKappas_maxrate_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b-');


  y = sum(ms_param1_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');

  y = sum(ms_param2_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');

  y = sum(ms_param3_sumrateKappas_maxrate_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b--');


  y = sum(ms_param1_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');

  y = sum(ms_param2_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');

  y = sum(ms_param3_sumrateKappas_maxrate_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'b:');


  y = sum(ms_param1_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');

  y = sum(ms_param2_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');

  y = sum(ms_param3_sumrateKappas_maxsinr_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r-');


  y = sum(ms_param1_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');

  y = sum(ms_param2_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');

  y = sum(ms_param3_sumrateKappas_maxsinr_ignore_smart,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r--');


  y = sum(ms_param1_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');

  y = sum(ms_param2_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');

  y = sum(ms_param3_sumrateKappas_maxsinr_ignore_oblivious,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'r:');


  y = sum(ms_param2_sumrateKappas_tdma_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k-');

  y = sum(ms_param3_sumrateKappas_tdma_compensate,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k-');


  y = sum(ms_param2_sumrateKappas_tdma_ignore,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k:');

  y = sum(ms_param3_sumrateKappas_tdma_ignore,1);
  bars = zeros(length(loop_kappas),1);
  for ii_kappa = 1:length(loop_kappas)
    tmp = y(:,ii_kappa,:,:,:); bars(ii_kappa) = 1.96/sqrt(Nnetworks*Nsim)*std(tmp(:));
  end
  errorbar(loop_kappas,mean(mean(y,4),5),bars,'k:');


  xlabel('Linear MS kappas'); ylabel('Sum rate');
end