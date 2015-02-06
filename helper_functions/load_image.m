function im = load_image(fname)
%
% Load in the selected image, special handling if it comes from a known
% dataset of linear natural scene images (Van Hateren or McGill)
%
% INPUT:
%
%       fname:  name of file to load
%
% OUTPUT
%
%       im:     matrix with light intensity values
%
% Emily Cooper, 2015

if any(strfind(fname,'.iml'))               % Van Hateren Dataset IML images from Bethge lab website (http://bethgelab.org/datasets/vanhateren/)
    
    f   = fopen(fname, 'rb', 'ieee-be');	% open image file
    w  	= 1536; h = 1024;                   % set width and height
    im 	= fread(f, [w, h], 'uint16');       % read in contents
    im  = flipud(double(im)');              % flip dimensions
    
elseif any(strfind(lower(fname),'mcg'))     % McGill Calibrated Colour Image Database (http://tabby.vision.mcgill.ca)
    
    im      = rgb2linear(fname);                          % load linear image, this is a calibration function provided with the McGill iamges
    im      = im(:,:,1).*0.2989 + ...                     % convert RGB image to relative luminance
                im(:,:,2).*0.5870 + im(:,:,3).*0.1140;    
    
else                                        % just try to load in image file
    
    try   
        warning('Assuming that this image has pixel values that are linear with world light intensity');
        im = double(imread(fname));
        
        if size(im,3) > 1
            im = im(:,:,1).*0.2989 + ...                % convert RGB image to relative luminance
                im(:,:,2).*0.5870 + im(:,:,3).*0.1140;    
        end
        
    catch
        error('Unhandled file type, add this type to load_image.m');
    end
    
end