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

% First run for MS kappas
linear_bs_kappas = fixed_kappa;
linear_ms_kappas = loop_kappas;


% Set up scenario
TxImpairments_sumrateKappas_setup;


if(loop_ms)
  % First parameter (third_order_bs_kappa = inf)
  imp_params.bs_kappas = [0];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  ms_param1_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  ms_param1_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  ms_param1_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  ms_param1_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  ms_param1_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  ms_param1_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  ms_param1_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  ms_param1_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  ms_param1_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  ms_param1_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  ms_param1_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;


  % Second parameter
  imp_params.bs_kappas = [0 third_order_bs_kappas(1)];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  ms_param2_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  ms_param2_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  ms_param2_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  ms_param2_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  ms_param2_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  ms_param2_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  ms_param2_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  ms_param2_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  ms_param2_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  ms_param2_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  ms_param2_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;


  % Third parameter
  imp_params.bs_kappas = [0 third_order_bs_kappas(2)];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  ms_param3_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  ms_param3_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  ms_param3_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  ms_param3_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  ms_param3_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  ms_param3_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  ms_param3_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  ms_param3_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  ms_param3_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  ms_param3_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  ms_param3_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;
end


% Second run for BS kappas
linear_bs_kappas = loop_kappas;
linear_ms_kappas = fixed_kappa;


% Set up scenario
TxImpairments_sumrateKappas_setup;


if(loop_bs)
  % First parameter (third_order_bs_kappa = inf)
  imp_params.bs_kappas = [0];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  bs_param1_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  bs_param1_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  bs_param1_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  bs_param1_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  bs_param1_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  bs_param1_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  bs_param1_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  bs_param1_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  bs_param1_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  bs_param1_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  bs_param1_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;


  % Second parameter
  imp_params.bs_kappas = [0 third_order_bs_kappas(1)];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  bs_param2_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  bs_param2_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  bs_param2_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  bs_param2_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  bs_param2_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  bs_param2_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  bs_param2_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  bs_param2_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  bs_param2_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  bs_param2_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  bs_param2_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;


  % Third parameter
  imp_params.bs_kappas = [0 third_order_bs_kappas(2)];

  TxImpairments_sumrateKappas_run;

  % Set up storage containers
  bs_param3_sumrateKappas_tdma_compensate          = sumrateKappas_tdma_compensate;
  bs_param3_sumrateKappas_tdma_ignore              = sumrateKappas_tdma_ignore;
  bs_param3_sumrateKappas_tdma_noimp               = sumrateKappas_tdma_noimp;

  bs_param3_sumrateKappas_maxrate_compensate       = sumrateKappas_maxrate_compensate;
  bs_param3_sumrateKappas_maxrate_ignore_smart     = sumrateKappas_maxrate_ignore_smart;
  bs_param3_sumrateKappas_maxrate_ignore_oblivious = sumrateKappas_maxrate_ignore_oblivious;
  bs_param3_sumrateKappas_maxrate_noimp            = sumrateKappas_maxrate_noimp;

  bs_param3_sumrateKappas_maxsinr_compensate       = sumrateKappas_maxsinr_compensate;
  bs_param3_sumrateKappas_maxsinr_ignore_smart     = sumrateKappas_maxsinr_ignore_smart;
  bs_param3_sumrateKappas_maxsinr_ignore_oblivious = sumrateKappas_maxsinr_ignore_oblivious;
  bs_param3_sumrateKappas_maxsinr_noimp            = sumrateKappas_maxsinr_noimp;
end