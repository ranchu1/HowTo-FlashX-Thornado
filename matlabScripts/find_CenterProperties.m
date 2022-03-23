%% Read and Compute Shock Radius
cCGS      = 2.99792458d+10;
hCGS      = 6.62606885d-27;
ErgPerMeV = 1.602d-6;
hc3       = ( cCGS * hCGS / ErgPerMeV )^3;
inversehc3= 1/hc3;
baryonmass= 1.6606e-24; % average mass of a baryon [gram]

% inversehc3 = 1/(1.240e-6)^3;% MeV
lightspeed = 3.0e10;% cm


Times_Central           = zeros(size(ids_dens));

CentralDensity          = zeros([length(ids_dens),1]);
CentralElectronFraction = zeros([length(ids_dens),1]);
CentralEntropy          = zeros([length(ids_dens),1]);
NearEntropy             = zeros([length(ids_dens),1]);
CentralVelocity         = zeros([length(ids_dens),1]);
CentralLeptonFraction   = zeros([length(ids_dens),1]);


OuterDensity            = zeros([length(ids_dens),1]);
OuterVelocity           = zeros([length(ids_dens),1]);

if not (exist('Rad_Order'))
    Rad_Order == 'None';
end
if( Rad_Order == 'None' )
else
    [ ECenter, E ] = Emesh_nNodeE2( Emin, Emax, nE, Zoom );
    E = E';
end

for i_id=1:length(ids_dens)
    id = ids_dens(i_id);
    
    [ buffer_time, X1_r, X2, X3, ~, ~, D, T, Y,...
        SpecificTotalEnergy, Pressure, velx, entropy, shock, nstep ]...
        = ReadFluidFields_flashCHK(basenm,id,...
        directory);
    
    if( Rad_Order == 'None' )
        NeutrinoVolumeNumber = 0.;
    else
        [ buffer_time, X1_r, X2, X3, J_temp_1, H1_temp_1, H2_temp, H3_temp ]=...
            ReadRadiationFields_flashCHK(basenm,id,...
            directory, 1, nNodeE*(nE+2*swE)); %% Need FIX time, x1, is
        
        [ buffer_time, X1_r, X2, X3, J_temp_2, H1_temp_2, H2_temp, H3_temp ]=...
            ReadRadiationFields_flashCHK(basenm,id,...
            directory, 2, nNodeE*(nE+2*swE)); %% Need FIX time, x1, is
        
        J_Eulerian_1  = J_temp_1(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        H1_Eulerian_1 = H1_temp_1(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        
        J_Eulerian_2  = J_temp_2(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        H1_Eulerian_2 = H1_temp_2(swE*nNodeE+1:(swE+nE)*nNodeE,:);
        
        J_Lagrangian_1  = zeros(size(J_Eulerian_1));
        H1_Lagrangian_1 = zeros(size(H1_Eulerian_1));
        J_Lagrangian_2  = zeros(size(J_Eulerian_2));
        H1_Lagrangian_2 = zeros(size(H1_Eulerian_2));
        
        for iX = 1:2
            if(Rad_Order == 'O(v)')
                [ Dm, Im, nIter ] = ComputePrimitive_Newton( ...
                    J_Eulerian_1(:,iX), H1_Eulerian_1(:,iX), ...
                    velx(iX)/3.0e10, @EddingtonFactor_Minerbo );
                J_Lagrangian_1(:,iX)  = Dm;
                H1_Lagrangian_1(:,iX) = Im;
                
                [ Dm, Im, nIter ] = ComputePrimitive_Newton( ...
                    J_Eulerian_2(:,iX), H1_Eulerian_2(:,iX), ...
                    velx(iX)/3.0e10, @EddingtonFactor_Minerbo );
                J_Lagrangian_2(:,iX)  = Dm;
                H1_Lagrangian_2(:,iX) = Im;
            else
                J_Lagrangian_1(:,iX)  = J_Eulerian_1(:,iX);
                H1_Lagrangian_1(:,iX) = H1_Eulerian_1(:,iX);
                J_Lagrangian_2(:,iX)  = J_Eulerian_2(:,iX);
                H1_Lagrangian_2(:,iX) = H1_Eulerian_2(:,iX);
            end
            % neutrino number per volume (integrate over energy)
            NeutrinoVolumeNumber(iX) = inversehc3*ComputeNeutrinoLeptonVolumeNumberInt( ...
                J_Lagrangian_1(:,iX), J_Lagrangian_2(:,iX), E );
        end
    end
    
    for iX = 1:2
        % ne
        ElectronNumberDensity(iX) = ...
            ComputeElectronNumberDensity( Y(iX), D(iX) );
    end
    
    VolumeLeptonNumber = NeutrinoVolumeNumber + ElectronNumberDensity;
    
    
    CentralDensity(i_id)          = (D(1)+D(2))*0.5;
    CentralElectronFraction(i_id) = (Y(1)+Y(2))*0.5;
    CentralEntropy(i_id)          = (entropy(1)+entropy(2))*0.5;
    NearEntropy(i_id)             = (entropy(7)+entropy(8))*0.5;
    
    CentralVelocity(i_id)         = (velx(1)+velx(2))*0.5;
    
    CentralLeptonFraction(i_id)   = baryonmass*( VolumeLeptonNumber(1)/D(1)...
        + VolumeLeptonNumber(2)/D(2) )*0.5;
    
    OuterDensity(i_id)            = (D(end)+D(end-1))*0.5;
    OuterVelocity(i_id)           = (velx(end)+velx(end-1))*0.5;
    
    postbounceTime = buffer_time-T0;
    Times_Central(i_id) = postbounceTime;
end



function [ result ] = ComputeNeutrinoLeptonVolumeNumberInt( J_nue, J_nuebar, E_MeV )

result = 0.0;

% the first energy zone has dE = E(1)
result = (J_nue(1) - J_nuebar(1)) * E_MeV(1) * E_MeV(1) ...
    * E_MeV(1);

for ii = 2:max(size(E_MeV))
    % E^2 * dE
    result = result + (J_nue(ii) - J_nuebar(ii)) ...
        * E_MeV(ii) * E_MeV(ii) * (E_MeV(ii)-E_MeV(ii-1));
end

% 4 pi * () * E^2
result = 4*pi*result;

end

function [ result ] = ComputeNeutrinoEnergyInt( J_nue, J_nuebar, E_MeV )

result = 0.0;

% the first energy zone has dE = E(1)
result = (J_nue(1) + J_nuebar(1)) * E_MeV(1) * E_MeV(1) ...
    * E_MeV(1) * E_MeV(1);

for ii = 2:max(size(E_MeV))
    % E^3 * dE
    result = result + (J_nue(ii) + J_nuebar(ii)) ...
        * E_MeV(ii) * E_MeV(ii) * E_MeV(ii) * (E_MeV(ii)-E_MeV(ii-1));
end

% 4 pi * () * E^3
result = 4*pi*result;

end

function [ result ] = ComputeElectronNumberDensity( Ye, Density )
%%% Density [g/cm^3]

mb = 1.6606e-24; % average mass of a baryon [gram]
result = Ye * Density / mb;
end


function[ result ] = ComputeSphericalIntegral( Radius, FunctionValue )
%%%This function computes the integral of FunctionValue in spherical
%%%polar coordinate with radius array Radius

result = 0.0;
result = ...
    4*pi*FunctionValue(1)*Radius(1)*Radius(1)*Radius(1);
for ix = 2:length(Radius)
    result = result + 4*pi*Radius(ix)*Radius(ix)*...
        FunctionValue(ix)...
        *(Radius(ix)-Radius(ix-1));
end

end