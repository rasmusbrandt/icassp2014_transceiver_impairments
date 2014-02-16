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


% Scenario and algorithm parameters
Nnetworks = 4;		% number of user drops to simulate
Nsim = 1;         % number of channel realizations, per user drop

Pt_dBm = 26;          % transmit power [dBm]
sigma2r_dBm = -127;   % noise power over 15 kHz, 5dB noise figure

channel_model.name = 'triangular_CN01_iid_pathloss_antenna_gain_pattern'; % 'IBC_CN01_iid', 'hexagonal_CN01_iid_pathloss', 'triangular_CN01_iid_pathloss', 'triangular_CN01_iid_pathloss_antenna_gain_pattern'
channel_model.params.inter_site_distance = 500;
channel_model.params.guard_distance = 35;
channel_model.params.alpha = 37.6;
channel_model.params.beta = 15.3;
channel_model.params.penetration_loss_dB = 20;
channel_model.params.wrap_around = true; % Only for hexagonal cells

Kt = 3;             % number of transmitters
Kc = 2; Kr = Kt*Kc; % number of receivers per transmitter, and total number of receivers
Mt = 4;             % number of transmit antennas
Mr = 2;             % number of receive antennas

Nd = 2;             % number of data streams per user
Nd_maxsinr = 2;

C = ones(Kr,Kt);                              % clustering
D = kron(eye(Kt),ones(Kc,1));                 % user association
%Dmaxsinr = D; Dmaxsinr(2,1) = 0; Dmaxsinr(4,2) = 0; % 'scheduling' for MaxSINR
Dmaxsinr = D;


% Impairment parameters
imp_params.bs_kappas = 0; %[0 10^(26/20)];    % The first component is neglected, and taken from linear_bs_kappas
linear_bs_kappas = (1/100)*(1:1:15);          % kappas for BS linear impairments
linear_ms_kappas = (1/100)*(1:1:15);          % kappas for MS linear impairments


% Algorithm parameters
stop_crit = 1e-3;
weighted_maxsinr = false;