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

if(length(linear_bs_kappas) == 1)
  figure;
  plot(100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxrate_compensate(:,1,:,:,:),1),5),4)),      'b-',  ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxrate_ignore_smart(:,1,:,:,:),1),5),4)),    'b--', ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxrate_ignore_oblivious(:,1,:,:,:),1),5),4)),'b-.', ...
       100*linear_ms_kappas, mean(mean(sum(sumrateKappas_maxrate_noimp,1),3),2)*ones(size(linear_ms_kappas)),  'b:',  ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxsinr_compensate(:,1,:,:,:),1),5),4)),      'r-',  ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxsinr_ignore_smart(:,1,:,:,:),1),5),4)),    'r--', ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_maxsinr_ignore_oblivious(:,1,:,:,:),1),5),4)),'r-.', ...
       100*linear_ms_kappas, mean(mean(sum(sumrateKappas_maxsinr_noimp,1),3),2)*ones(size(linear_ms_kappas)),  'r:',  ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_tdma_compensate(:,1,:,:,:),1),5),4)),         'c-',  ...
       100*linear_ms_kappas, squeeze(mean(mean(sum(sumrateKappas_tdma_ignore(:,1,:,:,:),1),5),4)),             'c--', ...
       100*linear_ms_kappas, mean(mean(sum(sumrateKappas_tdma_noimp,1),3),2)*ones(size(linear_ms_kappas)),     'c:');
  legend('ImpAw-WMMSE', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'WMMSE (no impairments)', 'LinImpAw-MaxSINR', 'MaxSINR (smart UE)', 'MaxSINR (oblivious UE)', 'MaxSINR (no impairments)', 'ImpAw-TDMA', 'TDMA (unaware)', 'TDMA (no impairments)', 'Location', 'SouthEast');
  xlabel('100*MS\_kappa'); ylabel('Sum rate [bpcu]');
  title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d',Nsim,Kt,Kc,Mt,Mr,Nd));
elseif(length(linear_ms_kappas) == 1)
  figure;
  plot(100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxrate_compensate(:,:,1,:,:),1),5),4),             'b-',  ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxrate_ignore_smart(:,:,1,:,:),1),5),4),           'b--', ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxrate_ignore_oblivious(:,:,1,:,:),1),5),4),       'b-.', ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxrate_noimp,1),3),2)*ones(size(linear_bs_kappas)),'b:',  ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxsinr_compensate(:,:,1,:,:),1),5),4),             'r-',  ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxsinr_ignore_smart(:,:,1,:,:),1),5),4),           'r--', ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxsinr_ignore_oblivious(:,:,1,:,:),1),5),4),       'r-.', ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_maxsinr_noimp,1),3),2)*ones(size(linear_bs_kappas)),'r:',  ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_tdma_compensate(:,:,1,:,:),1),5),4),                'c-',  ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_tdma_ignore(:,:,1,:,:),1),5),4),                    'c--', ...
       100*linear_bs_kappas, mean(mean(sum(sumrateKappas_tdma_noimp,1),3),2)*ones(size(linear_bs_kappas)),   'c:');
  legend('ImpAw-WMMSE', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'WMMSE (no impairments)', 'LinImpAw-MaxSINR', 'MaxSINR (smart UE)', 'MaxSINR (oblivious UE)', 'MaxSINR (no impairments)', 'ImpAw-TDMA', 'TDMA (unaware)', 'TDMA (no impairments)', 'Location', 'SouthEast');
  xlabel('100*BS\_kappa'); ylabel('Sum rate [bpcu]');
  title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d',Nsim,Kt,Kc,Mt,Mr,Nd));
else
  [X_bs_kappas,Y_ms_kappas] = meshgrid(linear_bs_kappas,linear_ms_kappas);

  figure;
  surf(X_bs_kappas,Y_ms_kappas,squeeze(mean(mean(sum(sumrateKappas_maxrate_compensate,1),5),4)));
	xlabel('BS linear kappa'); ylabel('MS linear kappa');
end