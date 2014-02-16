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

function y = TxImpairments_func_BSImpairment_eta(x,imp_params)
  switch length(imp_params.bs_kappas)
    case 1
      y = imp_params.bs_kappas(1)*x;
    case 2
      y = imp_params.bs_kappas(1)*(x + cpower(x,3)/imp_params.bs_kappas(2)^2);
    case 3
      if(imp_params.bs_kappas(2) == Inf)
        y = imp_params.bs_kappas(1)*(x + cpower(x,5)/imp_params.bs_kappas(3)^4);
      else
        y = imp_params.bs_kappas(1)*(x + cpower(x,3)/imp_params.bs_kappas(2)^2 + cpower(x,5)/imp_params.bs_kappas(3)^4);
      end
  end
end