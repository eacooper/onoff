function filt = make_gaussian_rf(x,sig)

filt     = exp( -x.^2 / (2*sig^2) );      % central gaussian
filt     = filt'*filt;              % make it 2D
filt     = filt / sum(filt(:));     % normalize to sum to 1