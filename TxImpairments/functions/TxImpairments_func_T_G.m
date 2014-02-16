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

function [T,G,T_diag_UWUh] = TxImpairments_func_T_G(H,U,W,C,D)
  [~,Mt,Kr,Kt,~,~] = size(H);
  Nd = size(W,1);
  
  T = zeros(Mt,Mt,Kt); T_diag_UWUh = zeros(Mt,Mt,Kt);
  G = zeros(Mt,Nd,Kr);
  
  for l = 1:Kt
    % Cluster lists
    Cl = find(C(:,l) == 1)'; % MSs coordinated to by BS l
    Dl = find(D(:,l) == 1)'; % MSs served data    by BS l
    
    % Covariance matrix for BS l
    for k = Cl
      UWUh = U(:,:,k)*W(:,:,k)*U(:,:,k)'; UWUh = (UWUh + UWUh')/2;
      T(:,:,l) = T(:,:,l) + H(:,:,k,l)'*UWUh*H(:,:,k,l);
      T_diag_UWUh(:,:,l) = T_diag_UWUh(:,:,l) + H(:,:,k,l)'*diag(diag(UWUh))*H(:,:,k,l);
    end
    T(:,:,l) = (T(:,:,l) + T(:,:,l)')/2; % enforce Hermitian
    T_diag_UWUh(:,:,l) = (T_diag_UWUh(:,:,l) + T_diag_UWUh(:,:,l)')/2;
    
    % Effective channels for users belonging to this BS
    for k = Dl
      G(:,:,k) = H(:,:,k,l)'*U(:,:,k)*sqrtm(W(:,:,k));
    end
  end
end