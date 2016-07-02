function [im_new,crf]  = apply_crf(im,fltrs,path)
%
% Model the RGC contrast response functions for a given pathway
%
% INPUT:
%
%       im:     image matrix of RGC difference of Gaussian model output
%               values
%       fltrs:  structure containing RGC filters
%       path:   either 'ON' or 'OFF'
%
% OUTPUT:
%
%       im_new:    image matrix of RGC responses after applying CRF
%       crf:       look up table used to simulate RGC contrast response
%                   function
%
%
% CRFs are modeled as cumulative Gaussian to approximate those measured in
% the primate and guinea pig retina
%
% SOURCE:
% Zaghloul K.A., Boahen K., Demb J.B. (2003) Different circuits for on
% and off retinal ganglion cells cause different contrast sensitivities.
% Journal of Neuroscience 23, 2645-2654.
%
% Chichilnisky E.J., Kalmar R.S. (2002) Functional asymmetries in on and off
% ganglion cells of primate retina. The Journal of Neuroscience 22, 2737-2747.
%
% Emily Cooper, 2015

if exist('precomputed_RGC_CRFs.mat');
    load('precomputed_RGC_CRFs.mat');
    crf = crfs(ismember({crfs.rgc},fltrs.type)).(path);
else
    crf.cont = -1:1.0000e-04:1; % Weber contrasts over which to evaluate the CRF
    
    % ON and OFF pathways have different CRFs
    switch path
        
        case 'ON'
            
            crf.resp = 0.5 * ( 1 + erf( (crf.cont-0.375) / (0.3*sqrt(2)) ) );   % evaluate cumulative Gaussian model
            crf.resp = 0.5 * crf.resp/max(crf.resp);                            % normalize and scale to 1/2 OFF maximum response
            
        case 'OFF'
            
            crf.resp = 0.5 * ( 1 + erf( (-crf.cont-0.6) / (0.2*sqrt(2)) ) );    % evaluate cumulative Gaussian model
            crf.resp = crf.resp/max(crf.resp);                                  % normalize so max response is 1
            
        otherwise; error('Unknown pathway');
            
    end
    
    % compute filter response for each contrast value if the stimulus is a spot
    % of light with defined Weber Contrast
    crf.fltr   = compute_filter_equivalent_contrast(fltrs.(path).cntr, fltrs.(path).sur, crf.cont);
    
end
% convert each filter response to the correct RGC response for the equivalent contrast level
im_new     = interp1(crf.fltr,crf.resp,im,'linear');

% assign out of range filter responses (nans) to +/-100% weber contrast
im_new(isnan(im_new) & im < 0) = crf.resp(1);
im_new(isnan(im_new) & im > 0) = crf.resp(end);

