function new = filter_image(im,fltrs,path)
%
% Apply the RGC models to the image matrix for a given pathway
%
% INPUT:
%
%       im:     image matrix of linear intensity values
%       fltrs:  structure containing different filters for each RGC type
%       path:   either 'ON' or 'OFF'
%
% OUTPUT:
%
%       new:    structure containing each of the RGC response matrices
%
% Emily Cooper, 2015

% for each RGC filter type
for f = 1:length(fltrs)
    
    imdog       = apply_dog_filter(im, fltrs(f).(path).cntr, fltrs(f).(path).sur);  % apply the normalized DOG
    [imrgc,crf] = apply_crf(imdog,fltrs(f),path);                                   % modify with RGC contrast response function
    new(f).im   = imrgc;                                                            % add the matrix of RGC responses to data structure
    new(f).sum  = sum(imrgc(:));                                                    % take the sum of the response over all pixels
    new(f).crf  = crf;                                                              % store the CRF that was used for modeling

end