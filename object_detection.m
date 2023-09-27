% Read an image containing the object (head/face)
originalImage = imread('protrait_2.png');

% Convert the image to grayscale (if it's not already)
gray_img = rgb2gray(originalImage);

% Define 4 edge detection filter kernel
vertical_kernel_1   = [-1  0   1; -2  0  2; -1   0   1];
vertical_kernel_2   = [ 1  0  -1;  2  0 -2;  1   0  -1];
Horizontal_kernel_1 = [ 1  2   1;  0  0  0; -1  -2  -1];
Horizontal_kernel_2 = [-1 -2  -1;  0  0  0;  1   2   1];

% Perform convolution to detect vertical edges
edge_response_vertical_1   = filter2(vertical_kernel_1, double(gray_img));
edge_response_vertical_2   = filter2(vertical_kernel_2, double(gray_img));
edge_response_horizontal_1 = filter2(Horizontal_kernel_1, double(gray_img));
edge_response_horizontal_2 = filter2(Horizontal_kernel_2, double(gray_img));

% Apply a threshold to the edge response to extract edges
threshold = 200; % Adjust this threshold as needed
binary_edge_image_vertical_1 = edge_response_vertical_1 > threshold;
binary_edge_image_vertical_1 = convert_matrix(binary_edge_image_vertical_1, 1);

binary_edge_image_vertical_2 = edge_response_vertical_2 > threshold;
binary_edge_image_vertical_2 = convert_matrix(binary_edge_image_vertical_2, 2);

binary_edge_image_horizontal_1 = edge_response_horizontal_1 > threshold;
binary_edge_image_horizontal_1 = convert_matrix(binary_edge_image_horizontal_1, 3);

binary_edge_image_horizontal_2 = edge_response_horizontal_2 > 100;
binary_edge_image_horizontal_2 = convert_matrix(binary_edge_image_horizontal_2, 4);

% Display the original image and the binary edge map
figure;
subplot(6, 1, 1);
imshow(gray_img);
title('Original Image');

subplot(6, 1, 2);
imshow(binary_edge_image_vertical_1);
title('binary edge image vertical 1');

subplot(6, 1, 3);
imshow(binary_edge_image_vertical_2);
title('binary edge image vertical 2');

subplot(6, 1, 4);
imshow(binary_edge_image_horizontal_1);
title('binary edge image horizontal 1');

subplot(6, 1, 5);
imshow(binary_edge_image_horizontal_2);
title('binary edge image horizontal 2');


add_all_image = binary_edge_image_vertical_1 + binary_edge_image_vertical_2 + binary_edge_image_horizontal_1 + binary_edge_image_horizontal_2;
add_all_image = add_all_image > 2;

subplot(6, 1, 6);
imshow(add_all_image);
title('add all image');


figure;
subplot(1, 2, 1);
imshow(originalImage);
subplot(1, 2, 2);
filtered_image = uint8(add_all_image) .* gray_img;
imshow(filtered_image);
