function new = filter_image(im,fltrs,path)
%
%

for f = 1:length(fltrs)
    
    imdog       = apply_dog_filter(im, fltrs(f).(path).cntr, fltrs(f).(path).sur);
    [imrgc,crf] = apply_crf(imdog,fltrs(f),path);

    new(f).im   = imrgc;
    new(f).crf  = crf;
    new(f).sum  = sum(imrgc(:));
    
end