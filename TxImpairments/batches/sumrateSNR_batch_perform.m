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

% Set up scenario
TxImpairments_sumrateSNR_setup;


% First parameter
imp_params.bs_kappas = linear_kappas(1);
imp_params.ms_kappa  = linear_kappas(1);

TxImpairments_sumrateSNR_run;

% Set up storage containers
param1_sumrateSNR_tdma_compensate          = sumrateSNR_tdma_compensate;
param1_sumrateSNR_tdma_ignore              = sumrateSNR_tdma_ignore;
param1_sumrateSNR_tdma_noimp               = sumrateSNR_tdma_noimp;

param1_sumrateSNR_maxrate_compensate       = sumrateSNR_maxrate_compensate;
param1_sumrateSNR_maxrate_ignore_smart     = sumrateSNR_maxrate_ignore_smart;
param1_sumrateSNR_maxrate_ignore_oblivious = sumrateSNR_maxrate_ignore_oblivious;
param1_sumrateSNR_maxrate_noimp            = sumrateSNR_maxrate_noimp;

param1_sumrateSNR_maxsinr_compensate       = sumrateSNR_maxsinr_compensate;
param1_sumrateSNR_maxsinr_ignore_smart     = sumrateSNR_maxsinr_ignore_smart;
param1_sumrateSNR_maxsinr_ignore_oblivious = sumrateSNR_maxsinr_ignore_oblivious;
param1_sumrateSNR_maxsinr_noimp            = sumrateSNR_maxsinr_noimp;


% Second parameter
imp_params.bs_kappas = linear_kappas(2);
imp_params.ms_kappa  = linear_kappas(2);

TxImpairments_sumrateSNR_run;

% Set up storage containers
param2_sumrateSNR_tdma_compensate          = sumrateSNR_tdma_compensate;
param2_sumrateSNR_tdma_ignore              = sumrateSNR_tdma_ignore;
param2_sumrateSNR_tdma_noimp               = sumrateSNR_tdma_noimp;

param2_sumrateSNR_maxrate_compensate       = sumrateSNR_maxrate_compensate;
param2_sumrateSNR_maxrate_ignore_smart     = sumrateSNR_maxrate_ignore_smart;
param2_sumrateSNR_maxrate_ignore_oblivious = sumrateSNR_maxrate_ignore_oblivious;
param2_sumrateSNR_maxrate_noimp            = sumrateSNR_maxrate_noimp;

param2_sumrateSNR_maxsinr_compensate       = sumrateSNR_maxsinr_compensate;
param2_sumrateSNR_maxsinr_ignore_smart     = sumrateSNR_maxsinr_ignore_smart;
param2_sumrateSNR_maxsinr_ignore_oblivious = sumrateSNR_maxsinr_ignore_oblivious;
param2_sumrateSNR_maxsinr_noimp            = sumrateSNR_maxsinr_noimp;
