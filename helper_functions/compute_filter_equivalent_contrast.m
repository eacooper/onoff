function resp = compute_filter_equivalent_contrast(cen,sur,cont)
%
% Filter a series of spot images with defined contrast values to create
% contrast lookup table for this filter shape (i.e., which contrast value
% would produce this filter response?)
%
% INPUT:
%
%       cen:    central Gaussian of DOG
%       sur:    surround Gaussian of DOG
%       cont:   Weber contrasts to simulate
%
% OUTPUT:
%
%       resp:   filter response for each value in cont
%
%
% SOURCE: 
% Tadmor Y., & Tolhurst D.J. (2000) Calculating the contrasts that retinal 
% ganglion cells and lgn neurones encounter in natural scenes. 
% Vision Research 40: 3145-3157.
%
% Emily Cooper, 2015

% what is the area covered by of a spot of light fitting within the positive lobe of
% the filter?
spot_area                       = (cen - sur)/max(cen(:) - sur(:));    % normalized spot values (max value of 1)
spot_area(spot_area < 0.5)      = 0;                                   % fill spot with diameter of FWHM
spot_area(spot_area >= 0.5)     = 1;

bg  =  500;     % background illumination level

% for each Weber contrast
for j = 1:length(cont);
    
    % make an image of a spot of light on the background with this contrast level
    spot = (bg * cont(j) * spot_area) + bg;
    
    % response of rgc model to this Weber Contrast
    imcen   = sum(spot(:).*cen(:));             % center filtered
    imsur   = sum(spot(:).*sur(:));           	% surround filtered
    resp(j) = (imcen - imsur)./imsur;           % combine center - surround, and divisive normalization
    
end
