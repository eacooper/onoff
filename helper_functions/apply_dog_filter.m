function imdog = apply_dog_filter(im, cntr, sur)

imcen   = conv2( im, cntr, 'same' );    % center filtered
imsur   = conv2( im, sur, 'same' );     % surround filtered
imdog   = (imcen - imsur)./imsur;                % combine center - surround, and divisive normalization

edges   = ceil(size(cntr,1)/2);
imdog   = imdog(edges+1:end-edges,edges+1:end-edges);   % crop edges by 1/2 filter width
