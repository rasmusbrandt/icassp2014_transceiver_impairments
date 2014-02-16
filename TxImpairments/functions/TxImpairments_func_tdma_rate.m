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

function rates = TxImpairments_func_tdma_rate(H,V,D,sigma2r,imp_params)
  % Parameters
  [~,~,Kr,~,Nt,Nc] = size(H);

  % Consistency check
  if (Nt ~= 1)
    error('Only one realization supported.');
  end
  if (Nc ~= 1)
    error('Only one frequency bin supported.');
  end

  % Check user association set 
  if(any(sum((D == 1),2) > 1))
    error('Inconsistency in D. We do not allow for joint processing.');
  end

  % Get covariances (notice that C is replaced by 'full' clustering')
  [~,F,Qtdma] = TxImpairments_func_Q_F(H,V,ones(size(D)),D,sigma2r,imp_params);

  % Calculate rates
  rates = zeros(Kr,1);
  for k = 1:Kr
    % Calculate rate in robust way. The 'TDMA power scaling' is included in
    % the precoders, contrary to PracticalTDD.
    A = (Qtdma(:,:,k) - F(:,:,k)*F(:,:,k)')\(F(:,:,k)*F(:,:,k)');
    rates(k) = (1/Kr)*abs(sum(log2(1 + eig(A))));
  end
end