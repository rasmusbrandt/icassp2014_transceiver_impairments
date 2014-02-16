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
% sumrateSNR
% ===============


legends1{1} = 'WMMSE (aware)';
X1{1} = Pt_dBms; Y1{1} = [mean(mean(sum(param1_sumrateSNR_maxrate_compensate,1),3),4);mean(mean(sum(param2_sumrateSNR_maxrate_compensate,1),3),4)];
legends1{2} = 'WMMSE (aware UE only)';
X1{2} = Pt_dBms; Y1{2} = [mean(mean(sum(param1_sumrateSNR_maxrate_ignore_smart,1),3),4);mean(mean(sum(param2_sumrateSNR_maxrate_ignore_smart,1),3),4)];
legends1{3} = 'WMMSE (ignorant)';
X1{3} = Pt_dBms; Y1{3} = [mean(mean(sum(param1_sumrateSNR_maxrate_ignore_oblivious,1),3),4);mean(mean(sum(param2_sumrateSNR_maxrate_ignore_oblivious,1),3),4)];
legends1{4} = 'MaxSINR (aware)';
X1{4} = Pt_dBms; Y1{4} = [mean(mean(sum(param1_sumrateSNR_maxsinr_compensate,1),3),4);mean(mean(sum(param2_sumrateSNR_maxsinr_compensate,1),3),4)];
legends1{5} = 'TDMA (aware)';
X1{5} = Pt_dBms; Y1{5} = [mean(mean(sum(param1_sumrateSNR_tdma_compensate,1),3),4);mean(mean(sum(param2_sumrateSNR_tdma_compensate,1),3),4)];
legends1{6} = 'TDMA (ignorant)';
X1{6} = Pt_dBms; Y1{6} = [mean(mean(sum(param1_sumrateSNR_tdma_ignore,1),3),4);mean(mean(sum(param2_sumrateSNR_tdma_ignore,1),3),4)];

legend_location          = 'NW';
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
                             rgb('DarkCyan'); ];
plot_marker_sizes        = [4 4 4 4 4 4]; % points
plot_marker_types        = [ {'none'};
                             {'none'} ;
                             {'none'} ;
                             {'none'} ;
                             {'none'} ;
                             {'s'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 12], 'Transmit power    [dBm]', 'Average sum rate [bits/s/Hz]', [Pt_dBms(1) Pt_dBms(end)], [0 60], 0:5:40, 0:5:60);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
