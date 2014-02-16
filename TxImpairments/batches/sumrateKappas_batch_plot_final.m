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

if(loop_bs)
    legends2{1} = 'WMMSE (aware)';
        maxrate_compensate_2 = mean(mean(sum(bs_param2_sumrateKappas_maxrate_compensate,1),4),5);
        maxrate_compensate_3 = mean(mean(sum(bs_param3_sumrateKappas_maxrate_compensate,1),4),5);
    X2{1} = loop_kappas; Y2{1} = [maxrate_compensate_2;maxrate_compensate_3];
    legends2{2} = 'WMMSE (aware UE only)';
        maxrate_ignore_smart_2 = mean(mean(sum(bs_param2_sumrateKappas_maxrate_ignore_smart,1),4),5);
        maxrate_ignore_smart_3 = mean(mean(sum(bs_param3_sumrateKappas_maxrate_ignore_smart,1),4),5);
    X2{2} = loop_kappas; Y2{2} = [maxrate_ignore_smart_2;maxrate_ignore_smart_3];
    legends2{3} = 'WMMSE (ignorant)';
        maxrate_ignore_oblivious_2 = mean(mean(sum(bs_param2_sumrateKappas_maxrate_ignore_oblivious,1),4),5);
        maxrate_ignore_oblivious_3 = mean(mean(sum(bs_param3_sumrateKappas_maxrate_ignore_oblivious,1),4),5);
    X2{3} = loop_kappas; Y2{3} = [maxrate_ignore_oblivious_2;maxrate_ignore_oblivious_3];
    legends2{4} = 'MaxSINR (aware)';
        maxsinr_compensate_2 = mean(mean(sum(bs_param2_sumrateKappas_maxsinr_compensate,1),4),5);
        maxsinr_compensate_3 = mean(mean(sum(bs_param3_sumrateKappas_maxsinr_compensate,1),4),5);
    X2{4} = loop_kappas; Y2{4} = [maxsinr_compensate_2;maxsinr_compensate_3];

    legend_location          = 'SW';
		legend_font_size				 = 16;
    plot_line_widths         = 2*ones(7,1);
    plot_line_styles         = [ {'-'}  ;
                                 {'--'} ;
                                 {':'}  ;
                                 {'-.'} ; ];
    plot_line_colours        = [ rgb('Navy');
                                 rgb('Navy');
                                 rgb('Navy');
                                 rgb('Crimson'); ];
    plot_marker_sizes        = [4 4 4 4]; % points
    plot_marker_types        = [ {'none'} ;
                                 {'none'} ;
                                 {'none'} ;
                                 {'none'} ;];
    plot_marker_face_colour  = plot_line_colours;
    plot_marker_edge_colour  = plot_marker_face_colour;

    f2 = rmsbrt_figure([20 11], 'BS parameter', 'Average sum rate [bits/s/Hz]', [loop_kappas(1) loop_kappas(end)], [22 38], 0.01:0.02:0.15, 22:2:38);
    [plots,legend_handle] = rmsbrt_plot(X2,Y2,legends2,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
    set(legend_handle,'FontSize',14);
    grid off;
    
    % Parameter indicators
    plot(loop_kappas, maxrate_compensate_2, 'LineStyle', 'none', 'Marker', '+', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 8);
    plot(loop_kappas, maxrate_ignore_smart_2, 'LineStyle', 'none', 'Marker', '+', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 8);
    plot(loop_kappas, maxrate_ignore_oblivious_2, 'LineStyle', 'none', 'Marker', '+', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 8);
    plot(loop_kappas, maxsinr_compensate_2, 'LineStyle', 'none', 'Marker', '+', 'Color', rgb('Crimson'), 'MarkerFaceColor', rgb('Crimson'), 'MarkerSize', 8);
		
    plot(loop_kappas, maxrate_compensate_3, 'LineStyle', 'none', 'Marker', 'o', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 5);
    plot(loop_kappas, maxrate_ignore_smart_3, 'LineStyle', 'none', 'Marker', 'o', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 5);
    plot(loop_kappas, maxrate_ignore_oblivious_3, 'LineStyle', 'none', 'Marker', 'o', 'Color', rgb('Navy'), 'MarkerFaceColor', rgb('Navy'), 'MarkerSize', 5);
    plot(loop_kappas, maxsinr_compensate_3, 'LineStyle', 'none', 'Marker', 'o', 'Color', rgb('Crimson'), 'MarkerFaceColor', rgb('Crimson'), 'MarkerSize', 5);
end
