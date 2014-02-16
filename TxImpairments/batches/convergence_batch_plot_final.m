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

% ===============
% convergence
% ===============


iters = 1:stop_crit;

legends1{1} = 'WMMSE (aware)';
X1{1} = iters; Y1{1} = mean(sum(convergence_maxrate_rates_compensate,1),3);
legends1{2} = 'WMMSE (aware UE only)';
X1{2} = iters; Y1{2} = mean(sum(convergence_maxrate_rates_ignore_smart,1),3);
legends1{3} = 'WMMSE (ignorant)';
X1{3} = iters; Y1{3} = mean(sum(convergence_maxrate_rates_ignore_oblivious,1),3);
legends1{4} = 'MaxSINR (aware)';
X1{4} = iters; Y1{4} = mean(sum(convergence_maxsinr_rates_compensate,1),3);
legends1{5} = 'TDMA (aware)';
X1{5} = iters; Y1{5} = mean(sum(convergence_tdma_rates_compensate,1),3);
legends1{6} = 'TDMA (ignorant)';
X1{6} = iters; Y1{6} = mean(sum(convergence_tdma_rates_ignore,1),2)*ones(size(iters));

legend_location          = 'SE';
legend_font_size				 = 16;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'}  ;
                             {'--'} ;
                             {':'}  ;
                             {'-.'} ; 
                             {'-'}  ;
                             {':'}  ; ];
plot_line_colours        = [ rgb('Navy');
                             rgb('Navy');
                             rgb('Navy');
                             rgb('Crimson');
                             rgb('DarkCyan');
                             rgb('DarkCyan');];
plot_marker_sizes        = [6 6 6 4 10 6]; % points
plot_marker_types        = [ {'none'};
                             {'none'} ;
                             {'none'} ;
                             {'none'} ; 
                             {'none'} ;
                             {'none'} ;
                             {'none'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 11], 'Iteration number', 'Average sum rate [bits/s/Hz]', [0 stop_crit], [0 40], 0:10:stop_crit, 0:5:40);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;