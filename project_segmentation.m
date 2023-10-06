clear all; clc;
rgb = imread('protrait_2.png');
I = rgb2gray(rgb);
% Create mean filter and apply it on image
h = ones(9)/81;
I = uint8(conv2(I,h));
% Apply Binarization
BW = imbinarize(I);
% Extrat edges
B = ones(9);
BW = -imerode(BW,B) + BW;

% Thicken edges
BW = bwmorph(BW,'thicken');
% Fill holes in edges
BW = not(bwareaopen(not(BW), 300));

% Extract the vertical edge
B = strel('line',50,90);
BW = imdilate(BW,B);
BW = imerode(BW,B);
figure
imshow(BW)
% Eliminate the horizontal edge(10)
B = strel('line',10,0);
BW = imerode(BW,B);
figure
imshow(BW)
[nr, nc] = size(I);

% Set borthers of image = 0
Border_size_h = round(nr*.1);
Border_size_v = round(nc*.1);
BW(1:Border_size_h, :) = 0;
BW(nr-Border_size_h: nr, :) = 0;
BW(:, 1:Border_size_v) = 0;
BW(:, nc-Border_size_v:nc) = 0;

% Divide image to many blocks, each blocks = p**2 pixels
p = 3;

% Label block
for r=Border_size_h+1:3:nr-Border_size_h-1
    for c = Border_size_v+1:3:nc-Border_size_v-1
        rate = mean(BW(r:r+p, c:c+p), 'all')*100;
        if rate <= 25
            % If <= 25% pixles in the block are not euqal to 1
            % set all pixel values = 0
            BW(r:r+p, c:c+p) = 0;
        else
            BW(r:r+p, c:c+p) = 1;
        end
    end    
end
figure
imshow(BW)
% Find the 8-connected objects
L = bwlabel(BW,8);
% Find the bounding boxes for 8-connected objectes
% Get [xLeft, yTop, width, height]
BB = regionprops(L,'BoundingBox');
% Converts cell arrays to ordinary arrays
BB = cell2mat(struct2cell(BB));
[s1,s2] = size(BB);
BB = reshape(BB,4,s1*s2/4)';
% Compute width height ratio for bounding box
ratio = BB(:,3)./BB(:,4);
shapeind = BB(0.3 <ratio & ratio < 3,:);
[~,arealind] = max(shapeind(:,3).*shapeind(:,4));

% Create an ellipse shaped mask
% Ellipse center point (y, x)
c = [shapeind(arealind,2)+shapeind(arealind,4)/2, 
    shapeind(arealind,1)+shapeind(arealind,3)/2];   
% Ellipse radii squared (y-axis, x-axis)
r_sq = [shapeind(arealind,3)/2, shapeind(arealind,4)/2/1.2] .^ 2;  
[X, Y] = meshgrid(1:size(I, 2), 1:size(I, 1));
ellipse_mask = (r_sq(2) * (X - c(2)) .^ 2 + ...
                r_sq(1) * (Y - c(1)) .^ 2 <= prod(r_sq));
ellipse_mask = double(ellipse_mask(5:nr-4, 5:nc-4));
% Smooth mask for object
ellipse_mask = imgaussfilt(ellipse_mask, 3);
% Create mask for background
ellipse_mask_neg = double(abs(ellipse_mask-1));

% Apply Gaussian filter on image and mask
[r, g, b] = imsplit(rgb);

sigma = 3; 

smoothr = double(imgaussfilt(r, sigma)).*ellipse_mask_neg + ...
          double(r).*ellipse_mask;
smoothg = double(imgaussfilt(g, sigma)).*ellipse_mask_neg + ...
          double(g).*ellipse_mask;
smoothb = double(imgaussfilt(b, sigma)).*ellipse_mask_neg + ...
          double(b).*ellipse_mask;

% Plot the images
blurredImage = uint8(cat(3, smoothr, smoothg, smoothb));
figure1=figure('Position', [0, 0, 800, 600]);
subplot(1,2,1)
imshow(rgb)
title('Original')
subplot(1,2,2)
imshow(blurredImage)
title('Bokeh')

%# Check mask position
figure;
smoothr = double(imgaussfilt(r, sigma)).*ellipse_mask_neg;
smoothg = double(imgaussfilt(g, sigma)).*ellipse_mask_neg;
smoothb = double(imgaussfilt(b, sigma)).*ellipse_mask_neg;
blurredImageA = uint8(cat(3, smoothr, smoothg, smoothb));
imshow(blurredImageA)
title('Mask for face')

figure;
imshow(rgb)
for i = 1:length(shapeind)
    rectangle('Position', [shapeind(i, 1),shapeind(i, 2),shapeind(i,3), ...
        shapeind(i,4)/1.2], 'Curvature', [1 1],'EdgeColor', 'r')
end
title('Bounding areas')