function...
    [ Time, X1_nodes, X2_nodes, X3_nodes, computationalDomain,...
    controlvolumes, D, T, Y,...
    SpecificTotalEnergy, Pressure, velx, entropy, shock, nstep ]...
    = ReadFluidFields_flashCHK( AppName, FileNumber, Directory )
%%%%%
%%% Check Unit in checkpoint
%%% 'coordinates' is the block center location.
%%%%%
if( exist( 'Directory', 'var' ) )
    DirName = Directory;
else
    DirName = './Output';
end


FileName = [ DirName '/' AppName '_hdf5_chk_' sprintf( '%04d', FileNumber ) ];

buffer      = h5read( FileName, '/real scalars' );
Time        = MapData("time", buffer);
clear buffer;

computationalDomain = zeros([3,2]);
buffer      = h5read( FileName, '/real runtime parameters' );
computationalDomain(1,1) = MapData("xmin", buffer);
computationalDomain(1,2) = MapData("xmax", buffer);
computationalDomain(2,1) = MapData("ymin", buffer);
computationalDomain(2,2) = MapData("ymax", buffer);
computationalDomain(3,1) = MapData("zmin", buffer);
computationalDomain(3,2) = MapData("zmax", buffer);
clear buffer;

buffer      = h5read( FileName, '/integer scalars' );
nstep       = MapData("nstep", buffer);
clear buffer;

coordinates = h5read( FileName, '/coordinates' );
boundingBox = h5read( FileName, '/bounding box' );

buffer      = h5read( FileName, '/string scalars' );
geometry    = strtrim(buffer.value');
clear buffer;

buffer         = h5read( FileName, '/integer scalars' );
nxb            = MapData("nxb", buffer);
nyb            = MapData("nyb", buffer);
nzb            = MapData("nzb", buffer);
dimensionality = MapData("dimensionality", buffer);
controlvolumes = ComputeControlVolumes( dimensionality, geometry, boundingBox, nxb );
clear buffer;

buffer      = boundingBox(1,1,:); lowBX       = buffer(:);
buffer      = boundingBox(2,1,:); highBX      = buffer(:);
X1_nodes    = BlockCoordinate( lowBX, highBX, nxb );
clear buffer;
if( dimensionality > 1 )
    buffer      = boundingBox(1,2,:); lowBX       = buffer(:);
    buffer      = boundingBox(2,2,:); highBX      = buffer(:);
    X2_nodes    = BlockCoordinate( lowBX, highBX, nyb );
    clear buffer;
else
    X2_nodes          = 0;
end
if( dimensionality > 2 )
    buffer      = boundingBox(1,3,:); lowBX       = buffer(:);
    buffer      = boundingBox(2,3,:); highBX      = buffer(:);
    X3_nodes    = BlockCoordinate( lowBX, highBX, nzb );
    clear buffer;
else
    X3_nodes          = 0;
end

if( dimensionality == 1 )
    buffer = h5read( FileName, '/dens' ); D = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/temp' ); T = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/ye  ' ); Y = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/ener' ); SpecificTotalEnergy = buffer(:)'; clear buffer; % ?specific total energy
    buffer = h5read( FileName, '/pres' ); Pressure = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/velx' ); velx = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/shok' ); shock = buffer(:)'; clear buffer;
    buffer = h5read( FileName, '/entr' ); entropy = buffer(:)'; clear buffer;
end %% do only for 1D
end

function [ xnodes ] = BlockCoordinate( lowX, highX, nCell )
%% gives the coordinate of the cell center
%%% each block has nCell cell, lowX and highX are the boundaries of each
%%% block.
nCells = double(nCell);
nblock  = size(lowX, 1);
npoints = nblock * nCells;
xnodes  = zeros([1,npoints]);

for ii = 1:nblock
    dx_cell = (highX(ii)-lowX(ii))/nCells;
    for jj = 1:nCells
        kk = jj + (ii-1)*nCells;
        xnodes(kk) = ...
            lowX(ii) + (jj-1) * dx_cell + dx_cell*0.5;
    end
end

end

function [ controlVolumes ] ...
    = ComputeControlVolumes( dimensionality, geometry, boundingBox, nCell )

nCells = double(nCell);
controlVolumes = ones([1,size(boundingBox,3)*nCells]);

if( geometry == "cartesian" )
    for idim = 1:dimensionality
        for iblock = 1:size(boundingBox,3)
            controlVolumes((iblock-1)*nCells+1:iblock*nCells) = ...
                (boundingBox(2,idim,iblock)-boundingBox(1,idim,iblock))/nCells ...
                .* controlVolumes((iblock-1)*nCells+1:iblock*nCells);
        end
    end
end

if( geometry == "spherical" && dimensionality == 1 )
    conts = 4*pi/3;
    for iblock = 1:size(boundingBox,3)
        dr_cell = (boundingBox(2,1,iblock) - boundingBox(1,1,iblock))/nCells;
        low = boundingBox(1,1,iblock);
        for icell = 1:nCells
            up = low + dr_cell;
            controlVolumes((iblock-1)*nCells+icell) = ...
                conts * ( up^3 - low^3 );
            low = up;
            
        end
    end
    
end
end

function [ data ] = MapData(str, dataset)

nlength = size(dataset.name,2);
for ii = 1:nlength
    bufferstr = strtrim(dataset.name(:,ii)');
    if( bufferstr == str )
        data = dataset.value(ii);
        return
    end
end

end
