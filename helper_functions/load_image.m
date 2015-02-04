function im = load_image(fname)
%
%

if any(strfind(fname,'.iml'))       % Van Hateren Dataset IML images from Bethge lab website (http://bethgelab.org/datasets/vanhateren/)
    
    f   = fopen(filename, 'rb', 'ieee-be');	% open image file
    w  	= 1536; h = 1024;                   % set width and height
    im 	= fread(f, [w, h], 'uint16');       % read in contents
    im  = double(im)';                      % flip dimensions
    
elseif any(strfind(fname,'mcg'))   % McGill Calibrated Colour Image Database (http://tabby.vision.mcgill.ca)
    
    im      = rgb2linear(fname);                                            % load linear image
    im      = im(:,:,1).*0.2989 + im(:,:,2).*0.5870 + im(:,:,3).*0.1140;    % convert RGB image to relative luminance
    
else                                % just try to load in image file
    
    try     im = double(imread(fname));
    catch
        error('Unhandled file type, add this type to load_image.m');
    end
    
end