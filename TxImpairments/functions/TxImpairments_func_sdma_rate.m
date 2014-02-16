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

function rates = TxImpairments_func_sdma_rate(H,V,D,sigma2r,imp_params)
  % Parameters
  [~,~,Kr,Kt,Nt,Nc] = size(H);

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
  [Q,F] = TxImpairments_func_Q_F(H,V,ones(size(D)),D,sigma2r,imp_params);

  % Calculate rates
  rates = zeros(Kr,1);
  for l = 1:Kt
    Dl = find(D(:,l) == 1)';
    
    for k = Dl
      % Calculate rate in robust way
      A = (Q(:,:,k) - F(:,:,k)*F(:,:,k)')\(F(:,:,k)*F(:,:,k)');
      rates(k) = abs(sum(log2(1 + eig(A))));
    end
  end
end