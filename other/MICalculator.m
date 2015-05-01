classdef MICalculator
    %MICALCULATOR Wrapper of MI-related funcitons
    
    properties
    end
    
    methods(Static)
        %Returns mutual information
        function mi = calcMi(snr,constSize)
            if isinf(constSize)
                mi = log2(1+snr);
            elseif constSize == 4
                mi = 2*(1-0.8551*exp(-0.5718*(snr))-(1-0.8551)*exp((-1.55*(snr))));
            else
                error('Not implemented');
            end
        end
        
        %Inverts calcMI: Calculates SNR for a given MI
        function snr = calcSNR(mi,constSize)
            if isinf(constSize)
                snr = 2^mi - 1;
            elseif constSize == 4
                snr = zeros(size(mi));
                for in=1:numel(mi)
                    snr(in) = fzero(@(x) mi(in) - 2*(1-0.8551*exp(-0.5718*x)-(1-0.8551)*exp((-1.55*x))),1);
                end
            else
                error('Not implemented')
            end
        end
        
        %Calculates the index of the maximum mcs value
        function cqi = calcCQI(mcs,snr)
            %Check 
            if isa(mcs,'Mcs')
                cqi = 0;
                for in=1:length(mcs)
                    if mcs(in).rate < MICalculator.calcMi(snr,mcs(in).modulation);
                        cqi = cqi + 1;
                    end
                end
            else
                error('Input mcs is not of class Mcs')
            end
        end
    end
    
end

