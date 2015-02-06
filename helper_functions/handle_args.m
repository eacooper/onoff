function [fname, appix] = handle_args(varargin)
%
% handle the input arguments for onoff function
%
% INPUT:
%
%       varargin:   arguments that were supplied when onoff function was
%                   called
%
% OUTPUT:
%
%       fname:      name of file to load, should include full path
%       appix:      resolution of image file, number of visual arcminutes
%                   subtended by a single pixel
%
% Emily Cooper, 2015


% loop through inputs to look for different options
for n = 1:length(varargin)
    switch varargin{n}
        
        case 'file'
            % file name was given
            fname = varargin{n+1};
            
        case 'arcminperpixel'
            % resolution in arcminutes per pixel was given
            appix = varargin{n+1};
            
    end
end


% if the file name wasn't given, prompt for image file
if ~exist('fname','var')
    [fname,pathname,~]  = uigetfile('*');       % open file browser
    fname               = [pathname fname];     % concatenate file with path
end


% if the resolution wasn't given, see if we know it from the dataset,
% otherwise use a default
if ~exist('appix','var')
    
    if strfind(fname,'.iml')            % Van Hateren dataset IML images from Bethge lab website
        appix = 1;

    elseif strfind(lower(fname),'mcg')  % McGill dataset images
        appix = 0.5;
        
    else                                % just assume 1 arcminute per pixel
        display('Unknown image resolution, assuming 1 arcminute per pixel');
        appix = 1;
        
    end
end