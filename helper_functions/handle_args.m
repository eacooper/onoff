function [fname, appix] = handle_args(varargin)
%
%

varargin = varargin{:};
for n = 1:length(varargin)
    
    switch varargin{n}
        
        case 'file'
            fname = varargin{n+1};
            
        case 'arcminperpixel'
            appix = varargin{n+1};
            
    end
end

if ~exist('fname','var')
    fname = uigetfile('*');
end

if ~exist('appix','var')
    
    switch fname
        
        case strfind(fname,'.iml')  % Van Hateren dataset IML images from Bethge lab website
            appix = 1;
            
        case strfind(fname,'mcg')   % McGill dataset images
             appix = 0.5;
            
        otherwise                   % just assume 1 arcminute per pixel
            warning('Unknown image resolution, assuming 1 arcminute per pixel');
            appix = 1;
            
    end  
end