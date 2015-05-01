classdef Param < handle
    %PARAM Object containing transmission parameters and other information
    %for each transmitted packet
    
    properties
        idTransmission
        chan    %Channel
        mcs     %Selected MCS for transmission - index
        success %Correct decoding
        snr     %Average signal to noise ration (1/noise var);
        mcsObj  %MCS object used for transmission
        memoryLinkAdap   %"Hack" to introduce memory in the adaptation
    end
    
    methods
    end
    
end

