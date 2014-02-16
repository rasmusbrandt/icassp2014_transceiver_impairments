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

% User
%
% Class that describes a generic user (receiver or transmitter)
classdef User < handle
  properties
    
    % String describing the name of the user
    name = '';
    
    % Number of antennas that this user has
    no_antennas = 1;
    
    % Position of user
    position = [0 0];
    
  end % properties

  methods
    
    % Constructor
    function self = User(no_antennas, position)
      if nargin == 0
        return;
      elseif nargin == 1
        self.no_antennas = no_antennas;
      elseif nargin == 2
        self.no_antennas = no_antennas;
        self.position    = position;
      end
    end

  end % methods
end % classdef