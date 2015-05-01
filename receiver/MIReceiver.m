classdef MIReceiver < Receiver
    %MIReceiver
    
    properties
         mcsSet          %Set of available MCS
    end
    
    methods
        function o = MIReceiver(mcs)
            o = o@Receiver();
            o.mcsSet = mcs;
        end
    end
    
end

