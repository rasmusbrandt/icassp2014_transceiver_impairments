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

clear;


% Simulation parameters
rng('shuffle');     % Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng(); % Store seed  

sim_params.run_tdma    = true;
sim_params.run_maxrate = true;
sim_params.run_maxsinr = true;


% Scenario parameters
Nsim = 1;         % number of channel realizations to average over

Pt_dBm = 18;          % transmit power [dBm]
sigma2r_dBm = 0;   % noise power over 15 kHz, 5dB noise figure

channel_model.name = 'IBC_CN01_iid'; % 'IBC_CN01_iid', 'hexagonal_CN01_iid_pathloss', 'triangular_CN01_iid_pathloss', 'triangular_CN01_iid_pathloss_antenna_gain_pattern'
channel_model.params.inter_site_distance = 500;
channel_model.params.guard_distance = 35;
channel_model.params.alpha = 37.6;
channel_model.params.beta = 15.3;
channel_model.params.penetration_loss_dB = 20;
channel_model.params.wrap_around = true; % Only for hexagonal cells

Kt = 3;             % number of transmitters
Kc = 1; Kr = Kt*Kc; % number of receivers per transmitter, and total number of receivers
Mt = 2;             % number of transmit antennas
Mr = 2;             % number of receive antennas

Nd = 2;             % number of data streams per user
Nd_maxsinr = 1;

C = ones(Kr,Kt);                              % clustering
D = kron(eye(Kt),ones(Kc,1));                 % user association
%Dmaxsinr = D; Dmaxsinr(2,1) = 0; Dmaxsinr(4,2) = 0; % 'scheduling' for MaxSINR
Dmaxsinr = D;


% Impairment parameters
imp_params.bs_kappas = 5/100;% [10/100 Inf 10^(15/20)]; % [a,b,c] gives nu(x) = a*x*(1 + (x/b)^2 + (x/c)^4)
imp_params.ms_kappa = 5/100;    % [a] gives eta(x) = a*x


% Algorithm parameters
stop_crit = 30;
weighted_maxsinr = false;