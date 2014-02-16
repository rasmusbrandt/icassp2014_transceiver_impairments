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

iters = 1:stop_crit;

% Rate evolution
figure;
plot(iters, mean(sum(convergence_maxrate_rates_noimp,1),3),                'b:',  ...
     iters, mean(sum(convergence_maxrate_rates_compensate,1),3),           'b-',  ...
     iters, mean(sum(convergence_maxrate_rates_ignore_smart,1),3),         'b--', ...
     iters, mean(sum(convergence_maxrate_rates_ignore_oblivious,1),3),     'b-.', ...
     iters, mean(sum(convergence_maxsinr_rates_noimp,1),3),               'r:',  ...
     iters, mean(sum(convergence_maxsinr_rates_compensate,1),3),          'r-',  ...
     iters, mean(sum(convergence_maxsinr_rates_ignore_smart,1),3),        'r--', ...
     iters, mean(sum(convergence_maxsinr_rates_ignore_oblivious,1),3),    'r-.', ...
     iters, mean(sum(convergence_tdma_rates_noimp,1),3)*ones(size(iters)), 'c:',  ...
     iters, mean(sum(convergence_tdma_rates_compensate,1),3),              'c-',  ...
     iters, mean(sum(convergence_tdma_rates_ignore,1),3)*ones(size(iters)),'c--');
legend('WMMSE (no impairments)', 'ImpAw-WMMSE', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'MaxSINR (no impairments', 'LinImpAw-MaxSINR', 'WMMSE (smart UE)', 'WMMSE (oblivious UE)', 'TDMA (no impairments)', 'ImpAw-TDMA', 'TDMA', 'Location', 'SouthEast');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');
title(sprintf('Nsim = %d, Pt = %d [dBm], sigma2r = %d [dBm], Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d',Nsim,Pt_dBm,sigma2r_dBm,Kt,Kc,Mt,Mr,Nd));


% User rates evolution
figure;
subplot(1,4,1);
plot(iters, mean(convergence_maxrate_rates_noimp,3));
xlabel('Iteration no.'); ylabel('WMMSE (no impairments)');

subplot(1,4,2);
plot(iters, mean(convergence_maxrate_rates_compensate,3));
xlabel('Iteration no.'); ylabel('ImpAw-WMMSE');

subplot(1,4,3);
plot(iters, mean(convergence_maxrate_rates_ignore_smart,3));
xlabel('Iteration no.'); ylabel('WMMSE (smart UE)');

subplot(1,4,4);
plot(iters, mean(convergence_maxrate_rates_ignore_oblivious,3));
xlabel('Iteration no.'); ylabel('WMMSE (oblivious UE)');


% Filter evolution
if(Nsim == 1)
  figure;
  subplot(4,3,1);
  plot(iters, 10*log10(mean(convergence_maxrate_UWsqrt_compensate,3)));
  ylabel('||UW^{1/2}||^2 [dB]'); title('ImpAw-WMMSE');

  subplot(4,3,2);
  plot(iters, 10*log10(mean(convergence_maxrate_UWsqrt_ignore_smart,3)));
  ylabel('||UW^{1/2}||^2 [dB]'); title('WMMSE (smart UE)');

  subplot(4,3,3);
  plot(iters, 10*log10(mean(convergence_maxrate_UWsqrt_ignore_oblivious,3)));
  ylabel('||UW^{1/2}||^2 [dB]'); title('WMMSE (oblivious UE)');

  subplot(4,3,4);
  plot(iters, 10*log10(mean(convergence_maxrate_U_compensate,3)));
  ylabel('||U||^2 [dB]');

  subplot(4,3,5);
  plot(iters, 10*log10(mean(convergence_maxrate_U_ignore_smart,3)));
  ylabel('||U||^2 [dB]');

  subplot(4,3,6);
  plot(iters, 10*log10(mean(convergence_maxrate_U_ignore_oblivious,3)));
  ylabel('||U||^2 [dB]');

  subplot(4,3,7);
  plot(iters, 10*log10(mean(convergence_maxrate_W_compensate,3)));
  ylabel('tr(W) [dB]');

  subplot(4,3,8);
  plot(iters, 10*log10(mean(convergence_maxrate_W_ignore_smart,3)));
  ylabel('tr(W) [dB]');

  subplot(4,3,9);
  plot(iters, 10*log10(mean(convergence_maxrate_W_ignore_oblivious,3)));
  ylabel('tr(W) [dB]');

  subplot(4,3,10);
  plot(iters, 10*log10(mean(convergence_maxrate_V_compensate,3)));
  ylabel('||V||^2 [dB]');

  subplot(4,3,11);
  plot(iters, 10*log10(mean(convergence_maxrate_V_ignore_smart,3)));
  ylabel('||V||^2 [dB]');

  subplot(4,3,12);
  plot(iters, 10*log10(mean(convergence_maxrate_V_ignore_oblivious,3)));
  ylabel('||V||^2 [dB]');
end