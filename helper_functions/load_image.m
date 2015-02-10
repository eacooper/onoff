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
    
    % if it's a mat file, try to load it and look for a single matrix to use as the image
    if any(strfind(fname,'.mat'))
        
        data    = load(fname);      % load the mat file
        fields  = fieldnames(data); % get the names of loaded variables
        
        % you should have loaded just one variable, the 2D or 3D image matrix
        if length(fields) == 1 && ndims(data.(fields{1})) > 1
            im = data.(fields{1});  % if so, assign it to the im variable
        else
            error('If loading a mat file, by default the file must contain a single variable with the image matrix (2D or 3D)');
        end
        
    else                                                % otherwise, try to load it as an image
        
        try
            im = flipdim(double(imread(fname))./255,1);
        catch
            error('Unhandled file type, add this type to load_image.m');
        end
        
    end
    
    if size(im,3) > 1
        im = im(:,:,1).*0.2989 + ...                % convert RGB image to relative luminance if this is a color iamge
            im(:,:,2).*0.5870 + im(:,:,3).*0.1140;
    end
    
    display('Assuming this image has values that are linear with world light intensity');
    
end