function [on, off] = onoff(varargin)
%
% Predict the ON and OFF retinal ganglion cell responses to an image
%
% Example call: [on, off] = onoff('file','testimage1.png','arcminperpixel',1)
%
% If called with no arguments, you will be prompted to select an image
% file and the image viewing resolution will be assumed to be 1 arcminute
% per pixel.(
%
%       If the 'file' argument is supplied, it will instead try to load that 
%       file from the current working directory       
%
%       If the 'arcminperpixel' argument is supplied, it will use that value
%       instead of the default for the visual arcminutes subtended by a single
%       image pixel
%
%
% Note that image pixel values are assumed to be linear with world light
% intensity. This means that loading an image file directly from a camera
% will likely produce spurious predictions due to nonlinearities introduced in
% the image encoding. Loading a bitmap that has been designed for display
% on a linearized monitor, however, should produce meaningful predictions.
%
%
% For convenience, the auxillary load_images function can handle images that 
% come from the Van Hateren Natural Image Dataset
% (http://bethgelab.org/datasets/vanhateren/)
%
% or from the McGill Calibrated Colour Image Database
% (http://tabby.vision.mcgill.ca)
%
% ...so long as the file ending is ".iml" for Van Hateren or the file/path 
% contains the phrase "mcg" for McGill (and the McGill rgb2linear function
% is also in the path)
%
% Otherwise, various example images are provided in example_images
% directory for testing
%
%
% Accompanies: Cooper, E.A. & Norcia, A.M. Natural Scene Statistics and
% Early Visual Processing Predict Dark and Bright Cortial Asymmetries

addpath(genpath('.'));

[fname, appix]  = handle_args(varargin);
[im]            = load_image(fname);
rgcs            = load_croner_kaplan_rgc_info;
fltrs           = make_rgc_filters(rgcs, appix);

on              = filter_image(im,fltrs,'ON');
off             = filter_image(im,fltrs,'OFF');

show_results(im,on,off,rgcs,fltrs);

    
    
    
    keyboard
    
    
