%-----------------------------------------------------------------------
% This program linearise the RGB values of the McGill Colour Image Database
% according to the camera paramenteres  - CoolPix 5700(Pippin/Merry)
%
% Usage:          
%       [II] = rgb2linear(I)
% Input:
%       I  = Image name
% Output:
%       II  = Linearised image matrix.  II is a three dimensional image (type double)
%       II(:,:,1) = Red plane
%       II(:,:,2) = Green plane
%       II(:,:,3) = Blue plane
%
% Author: 
%       Adriana Olmos Mar/2004 - Mcgill Vision Research
% Last modification:
%       Feb/2005 - Exposure time stamp added
%       Mar/2004 - Main code
%-----------------------------------------------------------------------

function [II] = rgb2linear(imageName)

%Checking the input arguments
if nargin ~= 1
     error('Wrong number of input arguments')
end
%Error message
Message = ['The name of the camera used to take this image could not be found in the header.  Please make sure that the image is TIF format and downloaded from the McGill Colour Calibration Database.'];

% Checking that the Image can be read.
fid = fopen(imageName, 'r');
if (fid == -1)
  error(['The file could not be open, please check the image name, path and/or image permisions.']);
end

% Reading image
I = double(imread(imageName));
% Reading Image header
info = imfinfo(imageName);

% PARAMETRES
if (info(1).ImageDescription(1) == ' ')
 error(Message);
 else
  if (all(info(1).ImageDescription(1:5)=='pippi') && all(info(1).Format(1:3)=='tif'))
  % Camera parameters - Pippin
   a_R= 5.562441185;
   a_G= 8.876002262;   
   a_B= 7.233814813;
   b= 1.009696031;   
  else
    if(all(info.ImageDescription(1:5)=='merry') && all(info(1).Format(1:3)=='tif'))
     % Camera parameters - Merry
      a_R= 7.320565961;
      a_G= 12.0579051;
      a_B= 10.6112984;
        b= 1.008634316;
     else
      error(Message);
    end
  end
end

%Linearising the image
II = zeros(size(I));
II(:,:,1) = a_R.*(b.^I(:,:,1)-1);
II(:,:,2) = a_G.*(b.^I(:,:,2)-1);
II(:,:,3) = a_B.*(b.^I(:,:,3)-1);

%Exposure Time Stamp
ET = info(1).ImageDescription(8:length(info(1).ImageDescription)); % Exposure Time
display(['Exposure time = ' ET 'secs'])
II = II./str2double(ET);
