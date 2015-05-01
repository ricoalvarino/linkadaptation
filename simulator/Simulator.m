classdef Simulator < handle
    %SIMULATOR Performs simulation
    
    properties
        transmitter
        receiver
        channel
        nIter
        plotTag
        feedbackDelay
        feedbackLine
    end
    
    methods
        function o = Simulator(param)
            if nargin > 0
               o.setParam(param);
            end
        end
        
        function setParam(this,param)
            this.transmitter = param.transmitter;
            this.receiver = param.receiver;
            this.nIter = param.nIter;
            this.plotTag = param.plotTag;
            this.channel = param.channel;
            this.feedbackDelay = param.feedbackDelay;
            this.feedbackLine = DelayFeedback(this.feedbackDelay);
        end
        function s = getStats(this)
           s = this.receiver.getStats();
        end
        
        function simulate(this)
           %Initialize all the code
           this.transmitter.init();
           this.receiver.init();
           this.channel.init();
           
           for j=1:this.nIter
               %Generate message
                [message,param] = this.transmitter.newMessage();

                %Cross channel
                outChannel = this.channel.crossChannel(message,param);

                %Decode
                this.receiver.decode(outChannel,param);
                
                %Calculate feedback
                feedback = this.receiver.getFeedback();
                
                %Add to feedback delay
                this.feedbackLine.push(feedback);
                                
                %Process feedback by transmitter
                this.transmitter.feedback(this.feedbackLine.pop());
                
                %Process channel (if dual channel)
                if isa(this.channel, 'DualMIChannel')
                    this.transmitter.observeChannel(this.channel.crossForwardChannel(message,param),param);
                end
           end
        end
    end
    
end

