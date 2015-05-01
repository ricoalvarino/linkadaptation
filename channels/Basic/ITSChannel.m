classdef ITSChannel < MIChannel
    %ITS Simulates an intermediate tree shadowed channel
    
    properties(Constant)
         W = [0.3929; 0.3571; 0.25]; % State probability
         alpha  = [ -0.4;  -8.2; -17.0]; % dB
         Psi    = [  1.5;   3.9;  3.14]; % dB
         MP     = [-13.2; -12.7; -10.0]; % dB
    end
    
    methods
        
        function o = ITSChannel(snr)
           if nargin == 1
               o.snr = snr;
           end
           o.name = 'ITS';
        end
        
        function init(this)
           %Does nothing
        end
        
        %Gets as input nothing, and
        %as output the mutual information using Gaussian Codebooks.
        function output = crossChannel(this,input,param)
           %Generate the state:
           st = StatAckLinkAdap.generateDiscreteRV(this.W,1:length(this.W));
           %Calculate loo parameters according to Fontan
           mu = log(10.^this.alpha/20);
           d0 = (log(10.^this.Psi/20)).^2;
           b0 = 1/2*10.^( this.MP/10);
           %Generate LOS
           los = exp(mu(st)+randn(1,1)*sqrt(d0(st)));
           nlos = 1/sqrt(2)*b0(st)*crandn(1,1);
           
           h = los+nlos;
           
           param.chan = h;
           param.snr = this.snr;
           output = MICalculator.calcMi(abs(h)^2*this.snr,inf);
        end
    end
    
end

