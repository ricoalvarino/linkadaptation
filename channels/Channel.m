classdef (Abstract) Channel < handle
    %CHANNEL Abstract class for channel generation
    
    properties
        name
    end
    
    
    methods
        %Initializes the channel
        init(this)
        
        %Gets one output of the channel from the input
        output = crossChannel(this,input,param)
    end
    
end

