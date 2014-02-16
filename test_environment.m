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

% setup
%
% Sets up the standard path

disp('This script checks whether Yalmip and Gurobi/Sedumi is installed.');
disp('If there are any error messages, please fix these before continuing.');
disp('Press any key.');
pause;

% Check for solvers
if(exist('gurobi','file'))
	disp('Gurobi exists, will be used.');
else
	disp('Gurobi does not exist.');
	
	if(exist('sedumi','file'))
		disp('Sedumi exists, will be used.');
	else
		error('Neither Gurobi nor Sedumi were found. Please install.');
	end
end

% Check if yalmip works
if(exist('yalmip','file'))
	disp('Yalmip exists. Press any key to run yalmip tests.');
	pause;
	yalmiptest;
	disp('If any errors were found, please fix these before continuing.');
else
	error('Yalmip not found. Please install from http://users.isy.liu.se/johanl/yalmip/');
end