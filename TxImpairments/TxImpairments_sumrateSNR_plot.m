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

figure;
plot(Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_noimp,4),3),1),            'b:',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_compensate,4),3),1),       'b-',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_ignore_smart,4),3),1),     'b--', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_ignore_oblivious,4),3),1), 'b-.', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_noimp,4),3),1),            'r:',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_compensate,4),3),1),       'r-',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_ignore_smart,4),3),1),     'r--', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_ignore_oblivious,4),3),1), 'r-.', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_tdma_noimp,4),3),1),               'c:',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_tdma_compensate,4),3),1),          'c-',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_tdma_ignore,4),3),1),              'c--');
legend('WMMSE (no impairments)', 'ImpAw-WMMSE', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'MaxSINR (no impairments)', 'LinImpAw-MaxSINR', 'MaxSINR (smart UE)', 'MaxSINR (oblivious UE)', 'TDMA (no impairments)', 'ImpAw-TDMA', 'TDMA', 'Location', 'SouthEast');
xlabel('Pt [dBm]'); ylabel('Sum rate [bits/s/Hz]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d',Nsim,Kt,Kc,Mt,Mr,Nd));

figure;
tdma_compensate = sum(mean(mean(sumrateSNR_tdma_compensate,4),3),1);
tdma_noimp      = sum(mean(mean(sumrateSNR_tdma_noimp,4),3),1);
plot(Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_noimp,4),3),1)./tdma_noimp,                 'b:',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_compensate,4),3),1)./tdma_compensate,       'b-',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_ignore_smart,4),3),1)./tdma_compensate,     'b--', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxrate_ignore_oblivious,4),3),1)./tdma_compensate, 'b-.', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_noimp,4),3),1)./tdma_noimp,                 'r:',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_compensate,4),3),1)./tdma_compensate,       'r-',  ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_ignore_smart,4),3),1)./tdma_compensate,     'r--', ...
     Pt_dBms, sum(mean(mean(sumrateSNR_maxsinr_ignore_oblivious,4),3),1)./tdma_compensate, 'r-.');
legend('WMMSE (no impairments)', 'ImpAw-WMMSE', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'MaxSINR (no impairments)', 'LinImpAw-MaxSINR', 'MaxSINR (smart UE)', 'MaxSINR (oblivious UE)', 'Location', 'SouthEast');
xlabel('Pt [dBM]'); ylabel('Practical DoF');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d',Nsim,Kt,Kc,Mt,Mr,Nd));