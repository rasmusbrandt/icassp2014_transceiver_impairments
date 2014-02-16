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

% SyntheticNetworkFactory
%
% The SyntheticNetworkFactory object provides a number of static methods, for
% generating Networks.
classdef SyntheticNetworkFactory < handle
  methods (Static)
    
    % Generates interference broadcast channel with iid Rayleigh channels
    function network = IBC_CN01_iid(no_receivers, no_transmitters, no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers)
      if nargin == 4
        no_realizations = 1;
      end
      if nargin <= 5
        no_subcarriers = 1;
      end
      
      % Create network
      network = multicellsim.Network();
      network.name = ...
        sprintf('IBC CN01 i.i.d. (Kr = %d, Kt = %d, Mr = %d, Mt = %d). %d realizations. Autogenerated from SyntheticNetworkFactory.', ...
                no_receivers, no_transmitters, no_rx_antennas, no_tx_antennas, no_realizations);
      network.model_name = 'IBC_CN01_iid';
      network.geography_type = 'canonical';
      
      % Get positions
      [BS_pos,MS_pos] = multicellsim.SyntheticNetworkFactory.create_canonical_geography(no_receivers,no_transmitters);
      
      % Create receivers
      for k = 1:no_receivers
        m = multicellsim.MS(no_rx_antennas,MS_pos(k,:));
        m.name = sprintf('MS %d',k);
        network.set_receiver(k,m);
      end
      
      % Create transmitters
      for l = 1:no_transmitters
        b = multicellsim.BS(no_tx_antennas,BS_pos(l,:));
        b.name = sprintf('BS %d',l);
        network.set_transmitter(l,b);
      end
        
      % Generate iid Rayleigh channels
      for k = 1:no_receivers
        for l = 1:no_transmitters
          c = multicellsim.SyntheticChannelFactory.CN01_iid(no_rx_antennas, no_tx_antennas, no_realizations, no_subcarriers);
          c.set_receiver(network.receivers{k});
          c.set_transmitter(network.transmitters{l});
          network.set_channel(k,l,c);
        end
      end
    end
    
    
    % Generates a hexagonal cellular network with path loss
    function network = hexagonal_CN01_iid_pathloss(no_transmitters, no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, guard_distance, wrap_around, alpha, beta, no_realizations, no_subcarriers)
      if nargin == 9
        no_realizations = 1;
      end
      if nargin <= 10
        no_subcarriers = 1;
      end
      
      if(wrap_around && (no_transmitters ~= 19))
        error('Can only do wrap around on Kt = 19 networks.');
      end
      
      no_receivers = no_transmitters*no_receivers_per_transmitter;
      
      % Create network
      network = multicellsim.Network();
      network.name = ...
        sprintf('Cellular hexagonal (Kt = %d, Kc = %d, Mr = %d, Mt = %d). Inter-site distance: %d m. %d realizations. Autogenerated from SyntheticNetworkFactory.', ...
                no_transmitters, no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, no_realizations);
      network.geography_type = 'hexagonal';
      
      % Get positions
      BS_pos = multicellsim.SyntheticNetworkFactory.create_hexagonal_cell_geography(no_transmitters, inter_site_distance);
      MS_pos = multicellsim.SyntheticNetworkFactory.generate_users_in_hexagonal_cells(BS_pos, no_receivers_per_transmitter, guard_distance);
      
      % Create receivers
      for k = 1:no_receivers
        m = multicellsim.MS(no_rx_antennas,MS_pos(k,:));
        m.name = sprintf('MS %d',k);
        network.set_receiver(k,m);
      end
      
      % Create transmitters
      for l = 1:no_transmitters
        b = multicellsim.BS(no_tx_antennas,BS_pos(l,:));
        b.name = sprintf('BS %d',l);
        network.set_transmitter(l,b);
      end
      
      % Calculate distances
      if(wrap_around)
        distance_matrix = network.get_wraparound_distances();
      else
        distance_matrix = network.get_distances();
      end
        
      % Generate channels with path loss
      for l = 1:no_transmitters
        for k = 1:no_receivers
          % Generate channel with path loss
          c = multicellsim.SyntheticChannelFactory.CN01_iid_pathloss(no_rx_antennas, no_tx_antennas, distance_matrix(k,l), alpha, beta, no_realizations, no_subcarriers);
          c.set_receiver(network.receivers{k});
          c.set_transmitter(network.transmitters{l});
          network.set_channel(k,l,c);
        end
      end
    end
    
    
    % Generates a triangular 3-cell (6-sector per cell, only one in simulation) network with path loss
    function network = triangular_CN01_iid_pathloss(no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, guard_distance, alpha, beta, no_realizations, no_subcarriers)
      if nargin == 7
        no_realizations = 1;
      end
      if nargin <= 8
        no_subcarriers = 1;
      end
      
      no_transmitters = 3;
      no_receivers = no_transmitters*no_receivers_per_transmitter;
      
      % Create network
      network = multicellsim.Network();
      network.name = ...
        sprintf('Cellular triangular (Kt = %d, Kc = %d, Mr = %d, Mt = %d). Inter-site distance: %d m. %d realizations. Autogenerated from SyntheticNetworkFactory.', ...
                no_transmitters, no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, no_realizations);
      network.geography_type = 'triangular';
      
      % Get positions
      BS_pos = multicellsim.SyntheticNetworkFactory.create_triangular_cell_geography(inter_site_distance);
      MS_pos = multicellsim.SyntheticNetworkFactory.generate_users_in_triangular_cells(BS_pos, no_receivers_per_transmitter, guard_distance);
      
      % Create receivers
      for k = 1:no_receivers
        m = multicellsim.MS(no_rx_antennas,MS_pos(k,:));
        m.name = sprintf('MS %d',k);
        network.set_receiver(k,m);
      end
      
      % Create transmitters
      for l = 1:no_transmitters
        b = multicellsim.BS(no_tx_antennas,BS_pos(l,:));
        b.name = sprintf('BS %d',l);
        network.set_transmitter(l,b);
      end
      
      % Calculate distances
      distance_matrix = network.get_distances();
        
      % Generate channels with path loss
      for l = 1:no_transmitters
        for k = 1:no_receivers
          % Generate channel with path loss
          c = multicellsim.SyntheticChannelFactory.CN01_iid_pathloss(no_rx_antennas, no_tx_antennas, distance_matrix(k,l), alpha, beta, no_realizations, no_subcarriers);
          c.set_receiver(network.receivers{k});
          c.set_transmitter(network.transmitters{l});
          network.set_channel(k,l,c);
        end
      end
    end
    
    
    function network = triangular_CN01_iid_pathloss_antenna_gain_pattern(no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, guard_distance, alpha, beta, no_realizations, no_subcarriers)
      if nargin == 7
        no_realizations = 1;
      end
      if nargin <= 8
        no_subcarriers = 1;
      end
      
      % Get network without antenna gain pattern
      network = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss(no_receivers_per_transmitter, no_rx_antennas, no_tx_antennas, inter_site_distance, guard_distance, alpha, beta, no_realizations, no_subcarriers);
      
      % Define bore sights (with Matlab +- pi praxis)
      bore_sights = [-90 30 150]*pi/180;
      
      % Get angles
      angle_matrix = network.get_angles(bore_sights);
      angle_3dB_3gpp = 35;
      min_antenna_gain_3gpp = 23;
      
      % Apply antenna pattern from 3GPP TR 25.996
      antenna_gain_matrix = -min(12*(angle_matrix./deg2rad(angle_3dB_3gpp)).^2, 10^(min_antenna_gain_3gpp/10)*ones(size(angle_matrix)));
      for l = 1:3
        for k = 1:3*no_receivers_per_transmitter
          for ii_Nt = 1:no_realizations
            for ii_Nf = 1:no_subcarriers
              network.channels{k,l}.coefficients(:,:,ii_Nt,ii_Nf) = sqrt(10^(antenna_gain_matrix(k,l)/10))*network.channels{k,l}.coefficients(:,:,ii_Nt,ii_Nf);
            end
          end
        end
      end
    end
    
    % ==============
    % HELPER METHODS
    % ==============
    
    % Creates a bipartite geography for canonical models
    function [BS_pos,MS_pos] = create_canonical_geography(no_receivers, no_transmitters)
      % Variables
      BS_pos = zeros(no_transmitters,2);
      MS_pos = zeros(no_receivers,2);
      
      % Create BS positions
      for l = 1:no_transmitters
        BS_pos(l,:) = [0 (l-1)*20];
      end
      
      % Create MS positions
      for k = 1:no_receivers
        MS_pos(k,:) = [10 (k-1)*20];
      end
    end
    
    
    % Creates a hexagonal cell geography
    function BS_pos = create_hexagonal_cell_geography(no_cells, inter_site_distance)
      % Variables
      BS_pos = zeros(no_cells,2);
      
      % First BS position
      BS_pos(1,:) = [0 0];
      
      % Build other positions
      ring = 1;
      placed_cells = 1;
      while (placed_cells < no_cells)
        for edge = 1:6 % hard coded since we are doing hexagonal cells!
          % Find initial position for this edge
          rot_angle_deg = -30 + (edge-1)*60; rot_angle_rad = rot_angle_deg*pi/180;
          rot_mat = [cos(rot_angle_rad) -sin(rot_angle_rad) ; 
                     sin(rot_angle_rad)  cos(rot_angle_rad) ];
          start_pos = ring*inter_site_distance*rot_mat*[1;0];
          
          % Which angle to add more cells in
          add_angle_deg = 90 + (edge-1)*60; add_angle_rad = add_angle_deg*pi/180;
          add_mat = [cos(add_angle_rad) -sin(add_angle_rad) ; 
                     sin(add_angle_rad)  cos(add_angle_rad) ];
          
          % The number of cells to place equals the ring number!
          for cell_on_edge = 1:ring
            if(placed_cells < no_cells)
              BS_pos(placed_cells+1,:) = (start_pos + (cell_on_edge-1)*inter_site_distance*add_mat*[1;0]).';
              placed_cells = placed_cells + 1;
            end
          end
        end
        
        ring = ring + 1;
      end
    end
    
    
    % Create a triangular 3-cell geography
    function BS_pos = create_triangular_cell_geography(inter_site_distance)
      % Variables
      BS_pos = [ 0                      sqrt((inter_site_distance/2)^2 + (inter_site_distance/(2*sqrt(3)))^2) ;
                -inter_site_distance/2 -inter_site_distance/(2*sqrt(3)) ;
                +inter_site_distance/2 -inter_site_distance/(2*sqrt(3)) ; ];
    end
    
    
    % Generates user positions within a given set of hexagonal cells
    function MS_pos = generate_users_in_hexagonal_cells(BS_pos, no_users_per_cell, guard_distance)
      % Dimensions
      Kt = size(BS_pos,1);
      Kr = Kt*no_users_per_cell;
      
      % Default guard distance
      if nargin == 2
        guard_distance = 30;
      end

      % Cell "small radius"
      half_inter_site_distance = (1/2)*sqrt((BS_pos(1,1) - BS_pos(2,1))^2 + (BS_pos(1,2) - BS_pos(2,2))^2);

      % Generate MS positions
      MS_pos = zeros(Kr,2);
      k = 1;
      for l = 1:Kt
        % Generate position uniformly at random over cell area
        for ii_user = 1:no_users_per_cell
          % Generate position within standard triangle +- 30 degrees, to
          % the right of BS. Apply guard distance to x coordinate.
          xtri = sqrt((half_inter_site_distance^2 - guard_distance^2)*rand(1) + guard_distance^2);
          ytri = -xtri/sqrt(3) + 2*xtri/sqrt(3)*rand(1);
          
          % Generate rotation angle
          theta_possibilities = (30 + (0:60:300))*pi/180;
          theta = theta_possibilities(randi(length(theta_possibilities)));
          
          % Get final position
          MS_pos(k,:) = ([cos(theta) -sin(theta);sin(theta) cos(theta)]*[xtri;ytri])' + BS_pos(l,:);
          k = k + 1;
        end
      end
    end
    
    
    % Generates user positions within triangular cells
    function MS_pos = generate_users_in_triangular_cells(BS_pos, no_users_per_cell, guard_distance)
      % Dimensions
      if(size(BS_pos,1) ~= 3)
        error('Triangular cell must be 3 sites.');
      end
      Kt = 3;
      Kr = Kt*no_users_per_cell;
      
      % Default guard distance
      if nargin == 2
        guard_distance = 30;
      end

      % Cell "small radius"
      half_inter_site_distance = (1/2)*sqrt((BS_pos(1,1) - BS_pos(2,1))^2 + (BS_pos(1,2) - BS_pos(2,2))^2);

      % Generate MS positions
      MS_pos = zeros(Kr,2);
      k = 1;
      for l = 1:Kt
        % Generate position uniformly at random over cell area
        for ii_user = 1:no_users_per_cell
          % Generate position within standard triangle [0,30] degrees, to
          % the right of BS. Apply guard distance to x coordinate.
          xtri = sqrt((half_inter_site_distance^2 - guard_distance^2)*rand(1) + guard_distance^2);
          ytri = xtri/sqrt(3)*rand(1);
          
          % Flip it over with probability 1/2
          if(rand(1) < 0.5)
            pos = [xtri;ytri];
          else
            pos = [xtri;-ytri];
            
            theta = 60*pi/180;
            pos = [cos(theta) -sin(theta);sin(theta) cos(theta)]*pos;
          end
          
          % Generate rotation angle
          switch l
            case 1
              theta = 240*pi/180;
            case 2
              theta = 0*pi/180;
            case 3
              theta = 120*pi/180;
          end
          
          % Get final position
          MS_pos(k,:) = ([cos(theta) -sin(theta);sin(theta) cos(theta)]*pos)' + BS_pos(l,:);
          k = k + 1;
        end
      end
    end
    
    
    % Helper to visualize the effect of path loss
    function visualize_pathloss(inter_site_distance, guard_distance, alpha, beta)
      PG = @(d) abs(10.^((-beta - alpha*log10(d))/10)); % for some reason gives complex output???

      p1 = -inter_site_distance; p2 = 0; p3 = inter_site_distance;
      x = linspace(-inter_site_distance,inter_site_distance);
      
      figure; hold on;
      pl_int  = plot(x,10*log10(PG(p1-x)),'r--');
      pl_this = plot(x,10*log10(PG(p2-x)),'b-');
      plot(x,10*log10(PG(p3-x)),'r--');
      pl_sum  = plot(x,10*log10(PG(p1-x)+PG(p3-x)),'r:');
      yl = ylim;
      pl_edge = plot([(p1+p2)/2 (p1+p2)/2], [yl(1) yl(2)], 'k:');
      plot([(p2+p3)/2 (p2+p3)/2], [yl(1) yl(2)], 'k:');
      pl_gd   = plot([p2-guard_distance,p2-guard_distance], [yl(1) yl(2)], 'k-.');
      plot([p2+guard_distance,p2+guard_distance], [yl(1) yl(2)], 'k-.');
      legend([pl_this, pl_int, pl_sum, pl_gd, pl_edge], 'This cell', 'Interfering cell', 'Sum of interferers','Guard distance','Cell edge');
    end
    
    
  end % methods (Static)
end % classdef