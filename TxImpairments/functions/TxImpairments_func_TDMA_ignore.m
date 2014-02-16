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

function [user_rates_tdma] = ...
  TxImpairments_func_TDMA_ignore(H,C,D,Pt,sigma2r,imp_params)

  % Parameters
  [Mr,Mt,Kr,Kt,~,~] = size(H);
  Kc = Kr/Kt;

  % Preallocate storage
  V = zeros(Mt,Mt,Kr);
  
  % Find precoders for all users
  for k = 1:Kr
    % BS serving this MS
    dinvk = find(D(k,:) == 1);

    % Only update if this MS is served
    if(dinvk)
      % Get sub channel gains
      [~,DD,VV] = svd(H(:,:,k,dinvk));
      DDdiag = diag(DD);
      d2 = [DDdiag.^2;zeros(Mt-length(DDdiag),1)]; s2d2 = sigma2r./d2;

      % Gains s2d2 come out sorted, since the SVD sorts the singular
      % values. I.e., s2d2 starts with the strongest channel, and ends
      % with the weakest. This is important for the order in which we
      % deactivate channels.

      % Start with only activating all channels
      Mg = 1:length(s2d2); 

      while true
        % Find waterlevel
        mu = (1/length(Mg))*(Pt*Kt/Kc + sum(s2d2(Mg)));

        % Get new power allocations
        Psub = mu - s2d2(Mg);

        % Is the waterlevel high enough?
        if Psub(end) > 0
          % We can accomodate all subchannels
          break;
        else
          % Not enough power, turn off weakest channel
          Mg(end) = [];
        end
      end

      % Final power allocation
      Palloc = [Psub;zeros(Mt-length(Psub),1)];

      % Precoder
      V(:,:,k) = VV*diag(sqrt(Palloc));
    end
  end
  
  
  % Performance 
  user_rates_tdma = TxImpairments_func_tdma_rate(H,V,D,sigma2r,imp_params);
  %user_rates_unc  = PracticalTDD_func_sdma_rate(H,V,D,sigma2r);

end