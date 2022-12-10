function...
    [ Time, X1_nodes, X2_nodes, X3_nodes, J, H1, H2, H3 ]...
    = ReadRadiationFields_flashCHK( AppName, FileNumber, Directory, iSpecies, nEnergyNodes )

if( exist( 'Directory', 'var' ) )
    DirName = Directory;
else
    DirName = './Output';
end

if( exist( 'iSpecies', 'var' ) )
    iS = iSpecies;
else
    iS = 1;
end

if( exist( 'nEnergyNodes', 'var' ) )
    nE = nEnergyNodes;
else
    nE = 32;
end

FileName = [ DirName '/' AppName '_hdf5_chk_' sprintf( '%04d', FileNumber ) ];

buffer      = h5read( FileName, '/real scalars' );
Time        = MapData("time", buffer);
clear buffer;

boundingBox = h5read( FileName, '/bounding box' );
buffer         = h5read( FileName, '/integer scalars' );
nxb            = MapData("nxb", buffer);
nyb            = MapData("nyb", buffer);
nzb            = MapData("nzb", buffer);
dimensionality = MapData("dimensionality", buffer);
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

J  = zeros(nE,max(size(X1_nodes)));
H1 = zeros(size(J));
H2 = zeros(size(J));
H3 = zeros(size(J));

for iE = 1:nE
    J_strings  = sprintf( 't%03d', iE + (iS-1) * 4 * nE );
    J(iE,:)    = ConvertData( FileName, J_strings);
    H1_strings = sprintf( 't%03d', iE + nE + (iS-1) * 4 * nE);
    H1(iE,:)   = ConvertData( FileName, H1_strings);
    H2_strings = sprintf( 't%03d', iE + nE * 2 + (iS-1) * 4 * nE);
    H2(iE,:)   = ConvertData( FileName, H2_strings);
    H3_strings = sprintf( 't%03d', iE + nE * 3 + (iS-1) * 4 * nE);
    H3(iE,:)   = ConvertData( FileName, H3_strings);
end
end

function [data] = ConvertData( FileName, string )
buffer1    = h5read( FileName, ['/' string] );
buffer2    = squeeze(buffer1);
data       = buffer2(:);
end

function [ xnodes ] = BlockCoordinate( lowX, highX, nCell )
%% gives the coordinate of the cell center
%%% each block has nCell cell, lowX and highX are the boundaries of each
%%% block.
nCells = double(nCell);
nblock  = size(lowX, 1);
npoints = nblock * nCells;
xnodes  = zeros([npoints, 1]);

for ii = 1:nblock
    dx_cell = (highX(ii)-lowX(ii))/nCells;
    for jj = 1:nCells
        kk = jj + (ii-1)*nCells;
        xnodes(kk) = ...
            lowX(ii) + (jj-1) * dx_cell + dx_cell*0.5;
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