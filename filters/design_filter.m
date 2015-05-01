function [b,a] = design_filter(fd,Rp,Rs,N)
%DESIGN_LOS_FILTER Designs an elliptic lowpass filter to implement
% correlation over a slow fading signal.
%
%[b,a]=DESIGN_NLOS_FILTER(fd,k,Rp,Rs) returns the coefficients of a lowpass
%elliptic filter with normalized cuttoff frequency fd/k, maximum bandpass ripple equal
%to Rp dB and minimum stopband attenuation Rs; if the latter values are not
%provided, the default values Rp = .5 and Rs = 50 are selected. The order
%is chosen automatically, trying to meet the specifications provided.
%
%fd would be the normalized Doppler frequency of a fast fading signal with
%the same parameters in terms of central frequency, speed, symbol period,
%etc. k is the fraction of wavelenghts along which the LOS signal can be
%consdiered correlated, that is, let dc be the correlation distance of the
%LOS component, then k=dc/lambda, k not neccessaryly integer.
%
%[b,a]=DESIGN_NLOS_FILTER(fd,k,Rp,Rs,N) uses order N.
%
%Jesús Arnau (suso@gts.uvigo.es)
%March 5, 2014.

ff = fd;

if nargin==1
    Rp = .5;
    Rs = 50;
    [N,Wpe] = ellipord(ff,1.5*ff,Rp,Rs);
elseif nargin==3
    [N,Wpe] = ellipord(ff,1.5*ff,Rp,Rs);
else
    Wpe = ff;
end
[b,a] = ellip(N,Rp,Rs,Wpe);
b = b/sqrt(Wpe);