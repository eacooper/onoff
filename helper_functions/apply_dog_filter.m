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

edges   = ceil(size(cntr,1)/2);                             % half filter width to be removed from image edges

% make sure image is large enough to remove boundary artifacts after filtering
if size(im,1) <= 2*edges || size(im,1) <= 2*edges
    error('image is too small to filter with RGCs');
else
    % convert to 1D filters if possible
    if mod(size(cntr,1),2) && mod(size(sur,1),2)                                    % if filters have an exact center
        cntr1d  = cntr(ceil(size(cntr,1)/2),:)./sum(cntr(ceil(size(cntr,1)/2),:));  % grab center Gaussian
        sur1d   = sur(ceil(size(sur,1)/2),:)./sum(sur(ceil(size(sur,1)/2),:));     % grab surround Gaussian
        imcen   = conv2( cntr1d, cntr1d', im, 'same' );                                 % center filtered
        imsur   = conv2( sur1d, sur1d', im, 'same' );                                   % surround filtered
    else
        imcen   = conv2( im, cntr, 'same' );                    % center filtered
        imsur   = conv2( im, sur, 'same' );                     % surround filtered
    end
    
    imdog   = (imcen - imsur)./imsur;                       % combine center - surround, and divisive normalization
    imdog   = imdog(edges+1:end-edges,edges+1:end-edges);   % crop edge off
    
end


