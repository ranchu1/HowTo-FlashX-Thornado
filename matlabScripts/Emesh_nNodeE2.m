function [ Center, Nodes, Width ] = ...
    Emesh_nNodeE2( Emin, Emax, nE, Zoom )

nNodeE = 2; %%%%% Need Fix
Width  = zeros(1,nE);
Center = zeros(1,nE);

if( Zoom > 1.0 - 1.0e-5 && Zoom <= 1.0 + 1.0e-5 )
    Width(1)  = (Emax - Emin)/nE;
else
    Width(1) = ( Emax - Emin ) * ( Zoom - 1.0 ) / (Zoom^nE - 1.0 );
end

Center(1) = Emin + 0.5 * Width(1);
for i = 2:nE
    Width(i)  = Width(i-1) * Zoom;
    Center(i) = Emin + sum( Width(1:i-1) ) + 0.5 * Width(i);
end

Nodes = zeros(1,nE*nNodeE);
xQ = [-sqrt(1/12), sqrt(1/12)]; %% 2-Point Gaussian Quadrature xs
for ic = 1:nE
    for iN = 1:nNodeE
        Nodes((ic-1)*nNodeE+iN) = ...
            Center(ic) + Width(ic) * xQ(iN);
    end
end


end