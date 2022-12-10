%% Read and Compute Luminosities
Times = zeros(size(ids));

for iS = 1:2 % 1 - nue, 2- nuebar
    for i_id=1:length(ids)
        id = ids(i_id);
        [ Time, X1_r, X2, X3, J_temp, H1_temp, H2_temp, H3_temp ]=...
            ReadRadiationFields_flashCHK(basenm,id,...
            directory, iS, nNodeE*(nE+2*swE)); %% Need FIX time, x1, is
        if(i_id == 1 && iS == 1 )
            Luminosities = zeros([length(ids),size(X1_r,1),2]);
        end
        J = J_temp(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        H1 = H1_temp(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        
        Luminosity = Luminosity1( E, X1_r, H1 );
        Luminosities(i_id,:,iS) = Luminosity;

        RMS = ComputeRMSEnergy( E, J );
        RMSs(i_id,:,iS) = RMS;

        postbounceTime = Time-T0;
        Times(i_id) = postbounceTime;
    end
end

% save('Temp_RMS_Lv.mat','Times','ids','E','Luminosities','RMSs','index_X');

function [ L1 ] = Luminosity1( E, X1, G1 )
%%% E in [MeV]
%%% X1 in [cm]
%%% Ls in [Erg]

cCGS      = 2.99792458d+10;
hCGS      = 6.62606885d-27;
ErgPerMeV = 1.602d-6;
hc3       = ( cCGS * hCGS / ErgPerMeV )^3;
Bethe     = 1.0d51 / ErgPerMeV;

L1 = zeros( size( X1, 1 ), 1 );
for iX = 1 : size( X1, 1 )
    L1(iX) ...
        = ( 4.0 * pi )^2 * ( X1(iX) )^2 ...
        * ( cCGS / hc3 ) * trapz( E, G1(:,iX) .* E.^3 ) * ErgPerMeV;
end
end

