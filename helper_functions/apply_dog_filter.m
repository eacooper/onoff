function imdog = apply_dog_filter(im, cntr, sur)
%
% Apply a normalized DOG filter to a image
%
% INPUT:
%
%       im:     image matrix of linear intensity values
%       cntr:   Gaussian filter for center of DOG
%       sur:    Gaussian filter for surround of DOG
%
% OUTPUT:
%
%       imdog:  image matrix after filtering, cropped to remove boudary
%               artifacts
%
% Emily Cooper, 2015


imcen   = conv2( im, cntr, 'same' );                    % center filtered
imsur   = conv2( im, sur, 'same' );                     % surround filtered
imdog   = (imcen - imsur)./imsur;                       % combine center - surround, and divisive normalization
edges   = ceil(size(cntr,1)/2);                         % half filter width to remove from image edges
imdog   = imdog(edges+1:end-edges,edges+1:end-edges);   % crop edge off
