classdef (Abstract) Transmitter < handle
    %Transmitter Abstract class for transmitter
    
    properties
        name
        msgCounter
    end
    
    methods
        
        function o = Transmitter()
           o.msgCounter = 0; 
        end
        
        init(this)
        
        feedback(this,fObject)
        
        [msg, param] = newMessage(this)
    end
    
end

