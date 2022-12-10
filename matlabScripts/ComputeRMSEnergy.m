function [RMS] = ComputeRMSEnergy( E, J )
%% This function compute the root mean square energy
%%% inputs: Energy array, E, and the zeroth moment (the number density),
%%% J(e,x) as a matrix of E and X
%%% output: the root mean square energy, result
%%% Note: assume nX > nE, and J = J(e,x)

nX = max(size(J));
nE = length(E);

RMS = zeros(nX,1);

for ix = 1:nX
    buffer = squeeze(J(:,ix));
    fifth = IntegrateWithEnergyPower(buffer, E, 5);
    third = IntegrateWithEnergyPower(buffer, E, 3);
    RMS(ix) = sqrt(fifth/max(third,1.0e-100));
end

end

function [result] = IntegrateWithEnergyPower(J1D, E, power)

result = 0.0;
weigth = E.^power;
kernel = J1D.*weigth;
result = kernel(1)*E(1);
for ie = 2:length(E)
    result = result + kernel(ie)*(E(ie)-E(ie-1));
end

return

end