function [rgcs] = load_croner_kaplan_rgc_info()
%
% load in the descriptions of retinal ganglion cells from Croner & Kaplan
% (1995) Receptive Fields of P and M Ganglion Cells Across the Primate
% Retina
%

% overall ratio of P to M (Figure 3)
rgcs.p_num        = 133;                   % number of P cells in dataset
rgcs.m_num        = 15;                    % number of M cells in dataset
rgcs.ratio_p2m    = rgcs.p_num/rgcs.m_num; % what is the ratio of P to M cells?

% cell types to model, for two eccentricities
% perifoval eccentricity is 0-5 deg for P and 0-10 for M, peripheral is 10-20 deg for both
rgcs.cell_type         = {'P foveal','P peripheral','M foveal','M peripheral'};
rgcs.ecc_deg           = {'0-5','10-20','0-10','10-20'};

% central radius from Table 1
rgcs.cntr_rad    = 60*[0.03 0.07 0.1 0.18];       % radius of central Gaussian in arcminutes

% surround Guassian radius scale (averages from pg12 text, Figure 4c).
% These are similar across cell types, so we use a single average value for
% modeling
p_sur_scale     = 6.7;
m_sur_scale     = 4.8;
rgcs.sur_scale = round(mean([p_sur_scale m_sur_scale]));

% Radius is given as half width at 1/e (~0.3679) * maximum of Gaussian (pg
% 9 bottom). To convert this to sigma, I divid by sqrt of 2
%
% FWHM = sigma * 2*sqrt(2*ln(2))
% FWXM = sigma * 2*sqrt(2*ln(1/X))  -- generalize to deal with any ratio X (e.g. 0.25 0.5 0.75 etc...)
% HWXM = sigma * sqrt(2*ln(1/X))    -- divide by 2 for half width
% HWEM = sigma * sqrt(2)            -- natural log of 1/(1/e) = 1
% sigma = HWEM / sqrt(2)            -- solve for sigma

rgcs.cntr_rad    = rgcs.cntr_rad/sqrt(2);

% pg 14 - receptive regions are domes of roughly constant volume, so we
% treat the Gaussians as unit sum





