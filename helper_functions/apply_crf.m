function [im_new,crf]  = apply_crf(im,fltrs,path)
%
%

%Weber contrasts to simulate
crf.cont = -1:1.0000e-04:1;

switch path
    
    case 'ON'
        
        crf.resp = 0.5 * ( 1 + erf( (crf.cont-0.375) / (0.3*sqrt(2)) ) );
        crf.resp = 0.5 * crf.resp/max(crf.resp);
        
    case 'OFF'
        
        crf.resp = 0.5 * ( 1 + erf( (-crf.cont-0.6) / (0.2*sqrt(2)) ) );
        crf.resp = crf.resp/max(crf.resp);
        
    otherwise error('Unknown pathway');
        
end

crf.fltr   = compute_filter_equivalent_contrast(fltrs.(path).cntr,fltrs.(path).sur,crf.cont);
im_new      = interp1(crf.fltr,crf.resp,im,'linear');

% assign out of range filter responses (nans) to 100% weber contrast
im_new(isnan(im_new) & im < 0) =  crf.resp(1);
im_new(isnan(im_new) & im > 0) =  crf.resp(end);

