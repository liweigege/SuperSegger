function [ imMosaic, imColor, imBW, imInv, imMosaic10 ] = makeConsensusImage( dataImArray,CONST,skip,mag,disp_flag)
% makeConsIm : Computes consensus fluorescence localization from cells in a cell files
%
% INPUT:
%   dataImArray : cell image array from makeConsensusArray

%
% OUPUT:
%  imMosaic : Image mosaic of cells that make up the consensus image
%   imColor : Color cons image (w/ black background)
%      imBW : Grayscale cons image
%     imInv : Color cons image (w/ white background)
%  imMosaic10 : Image mosaic of first 10 cells that make up the consensus image
%
% Copyright (C) 2016 Wiggins Lab
% University of Washington, 2016
% This file is part of SuperSeggerOpti.

if ~exist( 'skip', 'var' ) || isempty( skip )
    skip = 1;
end

if ~exist( 'mag', 'var' ) || isempty( mag )
    mag = 4;
end

T0 = numel( dataImArray.imCell ); % number of frames

for jj = 1:T0
    ssCell{jj} = size(dataImArray.imCell{jj} );
end

% merge the cell towers
[ ~, ~, dataImArray.tower, dataImArray.towerMask ] = ...
    towerMergeImages( dataImArray.imCell, dataImArray.maskCell, ssCell, 1, skip, mag, CONST );

% Merge the normalized towers into a single image
[ ~, ~, dataImArray.towerNorm, dataImArray.towerMask ] = ...
    towerMergeImages( dataImArray.imCellNorm, dataImArray.maskCell, ssCell, 1, skip, mag, CONST );

numIm = numel( dataImArray.tower );

if numIm  > 0
    % make the color map for the color image
    [ imMosaic, imColor, imBW, imInv, imMosaic10 ] = intDoMakeImage( dataImArray.towerNorm, ...
        dataImArray.towerMask, dataImArray.towerCArray, ...
        dataImArray.ssTot, dataImArray.cellArrayNum, CONST, disp_flag );
    imBWunmasked = dataImArray.towerNorm;
    imBWmask     = dataImArray.towerMask;
    
    
end

end

function [ imMosaic, imColor, imBW, imInv, imMosaic10] = ...
    intDoMakeImage( imSum, maskSum, cellArray, ssTot, cellArrayNum, ...
    CONST, disp_flag )
% intDoMakeImage : internal function that creates the consensus image
% and cell mosaic
%
% INPUT :
%         imSum : Summed up imBW
%         maskSum : Summed up maskCons
%         imCellSum : Summed up imCell
%         cellArray : array of images for each cel
%         ssTot : Im size of tower mosaic of cell contributing to cons
%         cellArrayNum :
%         CONST : segmentation constants
%         disp_flag : 1 to display images
%
% OUTPUT :
%         imMosaic : Mosaic of towers of cells that make up the consensus image
%         imColor : Color cons image (w/ black background)
%          imBW : Grayscale cons image
%         imInv : Color cons image (w/ white background)

numCells = numel(cellArray);

% cellArrayPos: location in the image of each panel of the mosaic.
cellArrayPos = cell(1,numCells);

% make the color map for the color image
persistent colormap_;
if isempty( colormap_ )
    colormap_ = jet(256);
end


imTmp = 255*doColorMap( ag(imSum, min(imSum( maskSum>.95 )), max(imSum( maskSum>.95 )) ), colormap_ );
mask3 = cat( 3, maskSum, maskSum, maskSum );
imColor = uint8(uint8( double(imTmp).*mask3));
imBW  = uint8( double(ag(imSum, min(imSum( maskSum>.95 )), max(imSum( maskSum>.95 )) )) .* maskSum );
imTmp = 255*doColorMap( ag(imSum, min(imSum( maskSum>.95 )), max(imSum( maskSum>.95 )) ), 1-colormap_ );
mask3 = cat( 3, maskSum, maskSum, maskSum );
imInv = 255-uint8(uint8( double(imTmp).*mask3));

% plots the consensus image
if disp_flag
    figure(5)
    clf;
    imshow(imColor);
    drawnow;
end


del = 1;

% plots a mosaic of single cell towers
if CONST.view.falseColorFlag
    imMosaic = uint8(zeros( [ssTot(1), ssTot(2), 3] )) + del*255;
else
    imMosaic = uint8(zeros( [ssTot(1), ssTot(2), 3] ));
end


colPos = 1;
width10 = 0;
time10  = 0;

for ii = 1:numCells
    ss = size(cellArray{ii});
    if ii <= 10
        width10 = width10 + ss(2);
        time10  = max([ss(1),time10]);
    end
    
    imMosaic(1:ss(1), colPos:(colPos+ss(2)-1), :) = cellArray{ii};
    cellArrayPos{ii} = colPos + ss(2)/2;
    colPos = colPos + ss(2);
    
end

imMosaic10 = imMosaic( 1:time10, 1:width10, : );

if disp_flag
    figure(1);
    clf;
    imshow(imMosaic);
    title ('Mosaic of towers of single cells');
    if CONST.view.falseColorFlag
        cc = 'w';
    else
        cc = 'b';
    end
    
    for ii = 1:numCells
        text( cellArrayPos{ii}, 0, num2str(cellArrayNum{ii}), 'Color', cc, ...
            'HorizontalAlignment','center' );
    end
end

end
