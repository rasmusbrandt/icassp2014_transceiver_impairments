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

% MS
%
% Class that describes a mobile station (BS)
classdef MS < multicellsim.User
  properties
    velocity = 0;
  end % properties
  
  methods
    
    
    % Constructor
    function self = MS(no_antennas, position, velocity)
      if nargin == 0
        super_args = {};
      elseif nargin == 1
        super_args{1} = no_antennas;
      elseif nargin > 1
        super_args{1} = no_antennas;
        super_args{2} = position;
      end
      
      self = self@multicellsim.User(super_args{:});
      
      if nargin > 2
        self.velocity = velocity;
      end
    end
    
    
  end
end
