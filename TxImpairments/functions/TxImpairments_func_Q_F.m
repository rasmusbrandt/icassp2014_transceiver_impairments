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

function [Q,F,Qtdma,Qoblivious] = TxImpairments_func_Q_F(H,V,C,D,sigma2r,imp_params)
  % Parameters
  [Mr,Mt,Kr,Kt,~,~] = size(H);
  Nd = size(V,2);
  Kc = Kr/Kt;
  
  % Calculate full precoder matrices and Tx impairment covariances
  Vfull = zeros(Mt,Kc*Nd,Kt);
  Ctsq = zeros(Mt,Kt);
  for l = 1:Kt
    Dl = find(D(:,l) == 1)'; Ndl = length(Dl);
    
    Vfull(:,1:Ndl*Nd,l) = reshape(V(:,:,Dl),Mt,Ndl*Nd);
    
    for m = 1:Mt
      Ctsq(m,l) = TxImpairments_func_BSImpairment_eta(norm(Vfull(m,:,l)),imp_params)^2;
    end
  end
  
  % Calculate Rx impairment covariances
  Crsq = zeros(Mr,Kr);
  for k = 1:Kr
    for m = 1:Mr
      ntmp = 0;
      for l = 1:Kt
        Ftmp = H(:,:,k,l)*Vfull(:,:,l);
        ntmp = ntmp + norm(Ftmp(m,:))^2;
      end
      
      Crsq(m,k) = sigma2r + (imp_params.ms_kappa^2)*ntmp;
    end
  end
  
  % Calculate Tx impairment covariances under TDMA
  Ctsq_tdma = zeros(Mt,Kr);
  for k = 1:Kr
    for m = 1:Mt
      Ctsq_tdma(m,k) = TxImpairments_func_BSImpairment_eta(norm(V(m,:,k)),imp_params)^2;
    end
  end
  
  % Calculate Rx impairment covariances under TDMA
  Crsq_tdma = zeros(Mr,Kr);
  for k = 1:Kr
    dinvk = find(D(k,:) == 1);
    
    if(dinvk)
      Ftmp = H(:,:,k,dinvk)*V(:,:,k);
      for m = 1:Mr
        Crsq_tdma(m,k) = sigma2r + (imp_params.ms_kappa)^2*norm(Ftmp(m,:))^2;
      end
    end
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
      Q(:,:,k) = diag(Crsq(:,k));
      Qoblivious(:,:,k) = sigma2r*eye(Mr);
      for l = Cinvk
        Q(:,:,k) = Q(:,:,k) + H(:,:,k,l)*(Vfull(:,:,l)*Vfull(:,:,l)' + diag(Ctsq(:,l)))*H(:,:,k,l)';
        Qoblivious(:,:,k) = Qoblivious(:,:,k) + H(:,:,k,l)*(Vfull(:,:,l)*Vfull(:,:,l)')*H(:,:,k,l)';
      end
      Q(:,:,k) = (Q(:,:,k) + Q(:,:,k)')/2;
      Qoblivious(:,:,k) = (Qoblivious(:,:,k) + Qoblivious(:,:,k)')/2;
      
      % Effective channel
      F(:,:,k) = H(:,:,k,dinvk)*V(:,:,k);
      
      % Signal and impairments covariance under TDMA
      Qtdma(:,:,k) = diag(Crsq_tdma(:,k)) + H(:,:,k,dinvk)*(V(:,:,k)*V(:,:,k)' + diag(Ctsq_tdma(:,k)))*H(:,:,k,dinvk)';
      Qtdma(:,:,k) = (Qtdma(:,:,k) + Qtdma(:,:,k)')/2;
    end
  end
end