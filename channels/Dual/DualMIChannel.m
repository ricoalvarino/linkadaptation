classdef DualMIChannel < MIChannel
    %DUALMICHANNEL Interface for a dual MI channel (with correlated uplink and
    %downlink)
    
    properties
    end
    
    methods
        %Gets one output of the fw channel
        output = crossForwardChannel(this,input,param);
    end
    
end

