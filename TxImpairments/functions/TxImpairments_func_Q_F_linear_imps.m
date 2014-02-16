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

function [Q,F,Qtdma,Qoblivious] = TxImpairments_func_Q_F_linear_imps(H,V,C,D,sigma2r,imp_params)
  % Parameters
  [Mr,~,Kr,~,~,~] = size(H);
  Nd = size(V,2);
  
  % Check that it is linear
  if(length(imp_params.bs_kappas) ~= 1)
    error('Not linear nu!');
  end
  
  % Calculate covariances and effective channels
  Q = zeros(Mr,Mr,Kr); F = zeros(Mr,Nd,Kr);
  Qtdma = zeros(Mr,Mr,Kr);
  Qoblivious = zeros(Mr,Mr,Kr);
  for k = 1:Kr
    Cinvk = find(C(k,:) == 1);
    dinvk = find(D(k,:) == 1);

    if(dinvk)
      % Signal, interference and impairments covariance
      Q(:,:,k) = sigma2r*eye(Mr);
      Qoblivious(:,:,k) = sigma2r*eye(Mr);
      for l = Cinvk
        Dl = find(D(:,l) == 1)';
        
        for j = Dl
          Q(:,:,k) = Q(:,:,k) + H(:,:,k,l)*(V(:,:,j)*V(:,:,j)' + (imp_params.bs_kappas(1)^2)*diag(diag(V(:,:,j)*V(:,:,j)')))*H(:,:,k,l)' + ...
                                (imp_params.ms_kappa^2)*diag(diag(H(:,:,k,l)*(V(:,:,j)*V(:,:,j)')*H(:,:,k,l)'));
          Qoblivious(:,:,k) = Qoblivious(:,:,k) + H(:,:,k,l)*(V(:,:,j)*V(:,:,j)')*H(:,:,k,l)';
        end
      end
      Q(:,:,k) = (Q(:,:,k) + Q(:,:,k)')/2;
      Qoblivious(:,:,k) = (Qoblivious(:,:,k) + Qoblivious(:,:,k)')/2;
      
      % Effective channel
      F(:,:,k) = H(:,:,k,dinvk)*V(:,:,k);
      
      % Signal and impairments covariance under TDMA
      Qtdma(:,:,k) = H(:,:,k,dinvk)*(V(:,:,k)*V(:,:,k)' + (imp_params.bs_kappas(1)^2)*diag(diag(V(:,:,k)*V(:,:,k)')))*H(:,:,k,dinvk)' + ...
                     (imp_params.ms_kappa^2)*diag(diag(H(:,:,k,dinvk)*(V(:,:,k)*V(:,:,k)')*H(:,:,k,dinvk)')) + sigma2r*eye(Mr); 
      Qtdma(:,:,k) = (Qtdma(:,:,k) + Qtdma(:,:,k)')/2;
    end
  end
end