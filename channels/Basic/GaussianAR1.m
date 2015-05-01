classdef GaussianAR1 < MIChannel
    %GAUSSIANIidChannel Simulates a Gaussian IID channel. 
    
    properties
        rho
        prevSample
    end
    
    methods
        
        function o = GaussianAR1(snr,rho)
           if nargin >= 1
               o.snr = snr;
           end
            if nargin == 2
                o.rho = rho;
            else
                o.rho = 0.9;
            end
            o.prevSample = 1/sqrt(2)*crandn(1,1);
           o.name = 'Gaussian Channel';
        end
        
        function init(this)
           %Does nothing
        end
        
        %Gets as input nothing, and
        %as output the mutual information using Gaussian Codebooks.
        function output = crossChannel(this,input,param)
           h = sqrt(this.rho)*this.prevSample + sqrt(1-this.rho)*1/sqrt(2)*crandn(1,1);
           param.chan = h;
           param.snr = this.snr;
           this.prevSample = h;
           output = MICalculator.calcMi(abs(h)^2*this.snr,input.modulation);

        end
    end
    
end

