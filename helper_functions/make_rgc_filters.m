function fltrs = make_rgc_filters(rgcs, appix)
%
% Make difference of Gaussian filters to model RGC receptive fields
%
% INPUT:
%
%       rgcs:   structure with rgc info created by
%               load_croner_kaplan_rgc_info
%
%       appix:  visual arcminutes subtended by a single pixel in the image
%               presentation that is being simulated
%
% OUTPUT:
%
%       fltrs:  center and surround Gaussians of ON and OFF DOG filters for
%               each of the simulated RGC types (M and P pathways, foveal and
%               peripheral)
%
% Emily Cooper, 2015


% determine size of filter in pixels that will accommodate the largest
% Gaussian without producing edge artifacts
size = round(1.5*1.1*rgcs.sur_scale*max(rgcs.cntr_rad/appix));

% for each RGC cell type
for r = 1:length(rgcs.cell_type);

    % convert central radius from arcminutes into pixels
    cntr_rad_pix = rgcs.cntr_rad(r)/appix;

    % make 2D gaussians with the center and surround sigmas. ON and OFF
    % cells have slightly different sizes, so ON sigmas are scaled by 1.1
    % and OFF sigmas are scaled by 0.9 relative to the Croner and Kaplan
    % reference values
    fltrs(r).ON.cntr    = make_2d_gaussian(-size:size, 1.1 * cntr_rad_pix); 
    fltrs(r).ON.sur     = make_2d_gaussian(-size:size, 1.1 * cntr_rad_pix * rgcs.sur_scale); 
    
    fltrs(r).OFF.cntr   = make_2d_gaussian(-size:size, 0.9 * cntr_rad_pix); 
    fltrs(r).OFF.sur    = make_2d_gaussian(-size:size, 0.9 * cntr_rad_pix * rgcs.sur_scale); 
    
end
