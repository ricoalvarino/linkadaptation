classdef SimulationParam
    %SIMULATIONPARAM Class that contains the parameters for simulation
    
    properties
        transmitter  %Object
        receiver     
        channel
        nIter        %Number of iterations
        plotTag      %Legend of this curve
        feedbackDelay
    end
    
    methods
        function o = SimulationParam()
           o.feedbackDelay = 0; 
        end
    end
    
end

