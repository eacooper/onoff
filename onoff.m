function [on, off, rgcs] = onoff(varargin)
%
% Predict the ON and OFF retinal ganglion cell responses to an image.
% Separate predictions are generated for foveal and peripheral cells in the
% P and M pathways
%
% Example call: [on, off, rgcs] = onoff('file','checker.png','arcminperpixel',1)
%
% INPUT: If called with no arguments, you will be prompted to select an image
% file and the image viewing resolution will be assumed to be 1 arcminute
% per pixel.
%
%       If the 'file' argument is supplied, it will instead try to load that 
%       file from the current working directory       
%
%       If the 'arcminperpixel' argument is supplied, it will use that value
%       instead of the default for the visual arcminutes subtended by a single
%       image pixel
%
%
% Note that image element values are assumed to be linear with world light
% intensity. This means that loading an image file directly from a camera
% will likely produce spurious predictions due to nonlinearities introduced in
% the image encoding. Loading a bitmap that has been designed for display
% on a linearized monitor via a LUT, however, should produce meaningful 
% predictions. File types can be anything that MATLAB's imread can handle, 
% as well as .mat files containing a single variable that is a matrix
% containing the image. Images of matrices containing 3 channels will be
% assumed to be RGB and a luminance conversion will be applied.
%
% For convenience, the auxilary load_images function can handle images that 
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
% OUTPUT: 
%
%       on, off:    structures that contain matrices of the ON and OFF
%                   response magnitudes at each input image pixel. Matrixes are cropped
%                   relative to the input image to remove boundary artifacts from
%                   convolution
%
%       rgcs:       structure with info about the rgc model used to produce each
%                   matrix in the on and off structures
%
% Also produces plots illustrating the RGC models used, images of the
% RGC response magnitudes for P and M pathways, and a bar plot of the summed 
% responses for ON and OFF cells in each population (4 populations total, 
% plus a weighted average). Note that the "Weighted Ave" bars are the result 
% of giving the P pathway (combined foveal and peripheral) 9x more weight than 
% the M pathway (also combined). This manner of combination was used in the
% initial modeling paper, but the user may wish to modify this calculation
% for their own purposes.
%
% Emily Cooper, 2015
%
% Please cite accompanying paper: Cooper, E.A. & Norcia, A.M. Predicting Cortical Dark/bright 
% Asymmetries from Natural Image Statistics and Early Visual Transforms


addpath([pwd '/helper_functions:' pwd '/example_images']);  % add subfolders to the path
[fname, appix]  = handle_args(varargin{:});                 % handle the input args and load defaults 
[im]            = load_image(fname);                        % load in the selected image
rgcs            = load_croner_kaplan_rgc_info;              % load in the parameters for modeling the spatial receptive fields of RGCs
fltrs           = make_rgc_filters(rgcs, appix);            % make difference of Gaussian filters to model RGC receptive fields
on              = filter_image(im,fltrs,'ON');              % apply the RGC models to the image matrix for ON pathway
off             = filter_image(im,fltrs,'OFF');             % apply the RGC models to the image matrix for OFF pathway
show_results(im,on,off,rgcs,fltrs);                         % visualize results

    
    
