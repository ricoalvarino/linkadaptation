classdef DualMITransmitter < MITransmitter
    %DualMITransmitter: Interface for dual transmitters (observe RL)
    
    properties
    end
    
    methods
        function o = DualMITransmitter(txParam)
           o = o@MITransmitter(txParam); 
        end
        
        observeChannel(this,chanMI,param)
    end
    
end

