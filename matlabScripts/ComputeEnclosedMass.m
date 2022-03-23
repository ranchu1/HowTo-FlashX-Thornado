function [ result ] = ComputeEnclosedMass( R, Density )
%% This function compute the enclosed mass
%%% input: radius array, R, and density array, Density
%%% output: enclosed mass, result
%%% Note: No Unit Converting!!

result = zeros(size(R));
squareR = R.*R;
constant =4*pi;

integrated = 0.0;

%%% the first zone, using inner moste r = 0.0
integrated = integrated + Density(1)*squareR(1)*(R(1)-0.0); 
result(1) = constant * integrated;
%%% the rest zone
for ix = 2:length(R)
   integrated = integrated + Density(ix)*squareR(ix)*(R(ix)-R(ix-1)); 
   result(ix) = constant * integrated;
end

return

end