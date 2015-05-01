classdef TXParam
    %TXParam Class that contains the parameters of the transmitter.
    %It is used in the transmitter constructor
    
    properties
        mcsSet          %Set of available MCS
        linkAdap        %Link adaptation object
    end
    
    methods
        function o = TXParam(mcsSet,linkAdap)
            if nargin > 0
               o.mcsSet = mcsSet;
               o.linkAdap = linkAdap;
            end
        end
    end
    
end

