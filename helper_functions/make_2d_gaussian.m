function g = make_2d_gaussian(x,sig)
%
% Generate a symmetric 2D Gaussian filter
%
% INPUT:
%
%       x: values over which to evaluate the Gaussian
%       sig: sigma of Gaussian
%
% OUTPUT:
%
%       g: 2D Gaussian filter
%
% Emily Cooper, 2015

g     = exp( -x.^2 / (2*sig^2) );   % central gaussian
g     = g'*g;                       % make it 2D
g     = g / sum(g(:));              % normalize to sum to 1