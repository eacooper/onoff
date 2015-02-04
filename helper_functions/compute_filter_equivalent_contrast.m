function resp = compute_filter_equivalent_contrast(cen,sur,cont)
%
% filter series of spot images with defined contrast values to create
% contrast lookup table for these filter dimensions

bg      = 500;                                  % background level
blob    = (cen - sur)./max(cen(:) - sur(:));    % normalized spot values
blob(blob < 0) = 0;                             % remove lobes

% for each Weber contrast
for j = 1:length(cont);
    
    spot = (bg.*cont(j).*blob) + bg;
    
    % response of rgc model to this wc
    imcen   = sum(spot(:).*cen(:));                         % center filtered
    imsur   = sum(spot(:).*sur(:));                         % surround filtered

    imRGC   = (imcen - imsur)./imsur;                            % combine center - surround, and divisive normalization
    
    %filter response
    resp(j) = imRGC;
    
end