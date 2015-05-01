classdef MITransmitter < Transmitter
    %MITransmmitter Abstract class for transmitters that use MI
    
    properties
        mcsSet          %Set of available MCS
        linkAdap        %Link adaptation object
    end
    
    methods
        function o = MITransmitter(param)
            o = o@Transmitter();
            if nargin == 1
                o.mcsSet = param.mcsSet;
                o.linkAdap = param.linkAdap;
            end
        end
    end
    
end

