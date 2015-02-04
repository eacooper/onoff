function fltrs = make_rgc_filters(rgcs, appix)
%
%

% determine size of filter in pixels that will accomodate the largest
% Gaussian without producing edge artifacts
size = round(1.5*1.1*rgcs.sur_scale*max(rgcs.cntr_rad/appix));

for r = 1:length(rgcs.cell_type);

    cntr_rad_pix = rgcs.cntr_rad(r)/appix;

    fltrs(r).ON.cntr    = make_2d_gaussian(-size:size, 1.1 * cntr_rad_pix); 
    fltrs(r).ON.sur     = make_2d_gaussian(-size:size, 1.1 * cntr_rad_pix * rgcs.sur_scale); 
    
    fltrs(r).OFF.cntr   = make_2d_gaussian(-size:size, 0.9 * cntr_rad_pix); 
    fltrs(r).OFF.sur    = make_2d_gaussian(-size:size, 0.9 * cntr_rad_pix * rgcs.sur_scale); 
    
end
