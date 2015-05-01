classdef Mcs
    %MCS Wrapper for modulation and coding scheme
    
    properties
        rate
        modulation
    end
    
    methods
        function o = Mcs(rate,modulation)
            if nargin > 0
                o.rate = rate;
                o.modulation = modulation;  
            end
        end
    end
    
end

