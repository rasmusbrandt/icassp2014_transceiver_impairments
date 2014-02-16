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

% SyntheticChannelFactory
%
% A factory class that provides static methods for generating SyntheticChannels
classdef SyntheticChannelFactory < handle
  methods (Static)
    
    
    % Generates i.i.d. CN(0,1) MIMO channel
    function c = CN01_iid(no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers)
      if nargin <= 3
        no_subcarriers = 1;
      end
      if nargin <= 2
        no_realizations = 1;
      end
      
      % Generate i.i.d. CN(0,1) coefficients
      coefs = (1/sqrt(2))*(randn(no_rx_antennas,no_tx_antennas,no_realizations,no_subcarriers) + ...
                        1i*randn(no_rx_antennas,no_tx_antennas,no_realizations,no_subcarriers));
      
      % Create the Channel object and name it
      c = multicellsim.SyntheticChannel(coefs);
      c.name = sprintf('i.i.d. Rayleigh (Mr = %d, Mt = %d). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'CN01_iid';
    end
    
    
    % Generates rank-1 ULA channels
    function c = rank1_ULA(no_rx_antennas, no_tx_antennas, angles, no_realizations, no_subcarriers)
      if nargin <= 4
        no_subcarriers = 1;
      end
      if nargin <= 3
        no_realizations = 1;
      end
      
      if(no_subcarriers ~= 1)
        error('Extend this function for multiple subcarriers.');
      end
        
      % Array response
      a = @(theta,Na) exp(-1i*pi*(Na - (Na:-1:1)')*theta);
      
      % Generate rank-1 matrices
      coefs = zeros(no_rx_antennas,no_tx_antennas,no_realizations,no_subcarriers);
      
      for ii_Nr = 1:no_realizations
        theta_r = angles(ii_Nr,1); angles(ii_Nr,2); % Uniform angles
        
        coefs(:,:,ii_Nr,1) = a(theta_r,no_rx_antennas)*a(theta_t,no_tx_antennas)';
      end

      % Create the Channel object and name it
      c = multicellsim.SyntheticChannel(coefs);
      c.name = sprintf('Rank-1 ULA (Mr = %d, Mt = %d). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'rank1_ULA';
      c.model_parameters.angles = angles;
    end
    
    
    % Generates tapped delay line MIMO channel with exponentially decaying PDP,
    % and transforms to frequency domain using FFT (i.e., a MIMO-OFDM channel)
    function c = TDL_exp_PDP(no_rx_antennas, no_tx_antennas, no_taps, bandwidth, rms_delay_spread, no_realizations, no_subcarriers)
      
      Wt = bandwidth*rms_delay_spread;
      
      % Exponential PDP
      b = exp(-1/Wt);
      C = sum(b.^(0:(no_taps-1)));
      
      % Generate taps
      Htaps = zeros(no_rx_antennas, no_tx_antennas, no_realizations, no_taps);
      for ii_tap = 1:no_taps
        Htaps(:,:,:,ii_tap) = sqrt(b^(ii_tap-1))*(1/sqrt(2))*(randn(no_rx_antennas, no_tx_antennas, no_realizations) + ...
                                                             1i*randn(no_rx_antennas, no_tx_antennas, no_realizations));
      end
      Htaps = 1/sqrt(C)*Htaps; % Normalize 
      
      % Get OFDM version
      Hfreq = fft(Htaps, no_subcarriers, 4);
      
      % Create channel object and name it
      c = multicellsim.SyntheticChannel(Hfreq);
      c.name = sprintf('TDL Exponential PDP (Mr = %d, Mt = %d, W = %f, tau_rms = %f). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       no_rx_antennas, no_tx_antennas, bandwidth, rms_delay_spread, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'TDL_exp_PDP';
      c.model_parameters.no_taps = no_taps;
      c.model_parameters.bandwidth = bandwidth;
      c.model_parameters.rms_delay_spread = rms_delay_spread;
    end
    
    
    % Generates IID MIMO Rayleigh channels with path loss
    function c = CN01_iid_pathloss(no_rx_antennas, no_tx_antennas, distance, alpha, beta, no_realizations, no_subcarriers)
      if nargin <= 4
        no_subcarriers = 1;
      end
      if nargin <= 3
        no_realizations = 1;
      end
      
      % Get the channels without path loss
      c = multicellsim.SyntheticChannelFactory.CN01_iid(no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);

      % Apply path loss
      PG_dB = -beta - alpha*log10(distance); PG = 10^(PG_dB/10);
      c.coefficients = sqrt(PG)*c.coefficients;
      
      % Rename the Channel object
      c.name = sprintf('i.i.d. Rayleigh Path loss (Mr = %d, Mt = %d, alpha = %f, beta = %f). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       no_rx_antennas, no_tx_antennas, alpha, beta, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'iid_CN01_pathloss';
      c.model_parameters.distance = distance;
      c.model_parameters.alpha = alpha;
      c.model_parameters.beta = beta;
    end
    
    
    % Generates channels with the Kronecker structure (i.i.d. over realizations).
    function c = kronecker(rx_cov, tx_cov, no_realizations, no_subcarriers)
      no_rx_antennas = size(rx_cov,1);
      no_tx_antennas = size(tx_cov,1); 
      if nargin == 2
        no_realizations = 1;
      end
      
      % Get the channels without path loss
      c = multicellsim.SyntheticChannelFactory.iid_CN01(no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);

      % Apply Kronecker structure
      rx_cov_sqrt = sqrtm(rx_cov); tx_cov_sqrt = sqrtm(tx_cov);
      for ii_real = 1:no_realizations
        for ii_subc = 1:no_subcarriers
          c.coefficients(:,:,ii_real,ii_subc) = rx_cov_sqrt*c.coefficients(:,:,ii_real,ii_subc)*tx_cov_sqrt;
        end
      end
      
      % Rename the Channel object
      c.name = sprintf('Kronecker MIMO (Mr = %d, Mt = %d). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'kronecker';
      c.model_parameters.Rrx = rx_cov;
      c.model_parameters.Rtx = tx_cov;
    end
    
    
    % Generates channels with the Kronecker structure with path loss
    function c = kronecker_pathloss(rx_cov, tx_cov, distance, alpha, beta, no_realizations, no_subcarriers)
      if nargin <= 6
        no_subcarriers = 1;
      end
      if nargin <= 5
        no_realizations = 1;
      end
      
      % Get the channels without path loss
      c = multicellsim.SyntheticChannelFactory.kronecker(rx_cov, tx_cov, no_realizations, no_subcarriers);
      
      % Apply path loss
      PG_dB = -beta - alpha*log10(distance); PG = 10^(PG_dB/10);
      c.coefficients = sqrt(PG)*c.coefficients;
      
      % Rename the Channel object
      c.name = sprintf('Kronecker MIMO Path loss (Mr = %d, Mt = %d, alpha = %f, beta = %f). %d realizations, %d subcarriers. Autogenerated from SyntheticChannelFactory.', ...
                       size(rx_cov,1), size(tx_cov,1), alpha, beta, no_realizations, no_subcarriers);
      
      % Store channel model parameters
      c.model_name = 'kronecker_pathloss';
      c.model_parameters.distance = distance;
      c.model_parameters.alpha = alpha;
      c.model_parameters.beta = beta;
    end
    
    
  end % methods (Static)
  
end % classdef