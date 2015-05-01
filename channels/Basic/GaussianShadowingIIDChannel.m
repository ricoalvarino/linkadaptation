classdef GaussianShadowingIIDChannel < MIChannel
    %GAUSSIANIidChannel Simulates a Gaussian IID channel. 
    
    properties
        
    end
    
    methods
        
        function o = GaussianShadowingIIDChannel(snr)
           if nargin == 1
               o.snr = snr;
           end
           o.name = 'Gaussian + Shadowing Channel';
        end
        
        function init(this)
           %Does nothing
        end
        
        %Gets as input nothing, and
        %as output the mutual information using Gaussian Codebooks.
        function output = crossChannel(this,input,param)
           h = 10^randn(1)*1/sqrt(2)*crandn(1,1);
           param.chan = h;
           param.snr = this.snr;
           output = MICalculator.calcMi(abs(h)^2*this.snr,inf);
        end
    end
    
end

