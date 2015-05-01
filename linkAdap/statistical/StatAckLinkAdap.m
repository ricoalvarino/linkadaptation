classdef StatAckLinkAdap < LinkAdap
    %StatACKLinkAdap Learns the error probability of each of the MCS by
    %observing only the ACK/NAK information
    
    properties
        pickRandom
        targetPER
        numberObservations
        numberErrors
        random
    end
    
    methods
        function o = StatAckLinkAdap(mcsSet,targetPER,pickRandom)
           o = o@LinkAdap(mcsSet);
           %Initialize parameters
           if nargin<3
               o.pickRandom = 0.01;
           else
                o.pickRandom = pickRandom;
           end
           o.numberObservations = ones(size(mcsSet));
           o.numberErrors = targetPER*ones(size(mcsSet));
           o.targetPER = targetPER;
           o.random = 1;
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            this.numberObservations(fb.param.mcs) = this.numberObservations(fb.param.mcs) + 1;
            if fb.success == 0      %NAK
                this.numberErrors(fb.param.mcs) = this.numberErrors(fb.param.mcs) + 1;
            end            
        end
        
        function mcs = getMCS(this,param)
            mcs = 1;
            p = StatAckLinkAdap.calculateErrorProb(this.numberErrors,this.numberObservations);
            if this.random == 0
                for in=2:length(this.numberObservations)
                   if p(in) <= this.targetPER
                      mcs = mcs + 1; 
                   end
                end
            else
               mcs =  StatAckLinkAdap.generateDiscreteRV(this.probabilityLA(),1:length(this.numberObservations));
            end
            
            %With probability pickRandom we choose a higher MCS than the
            %current one. Specifically, we select the MCS with less
            %observations
            if rand < this.pickRandom
                keyboard
                m1 = (mcs+1):length(this.numberObservations);
                if isempty(m1)
                    mcs = randi([1, length(this.mcsSet)]);
                else
                    [~,index] = min(this.numberObservations(m1));
                    mcs = index(1)+mcs;
                end
                
            end
            
        end
        
        function init(this)
            this.numberObservations = ones(size(this.numberObservations));
            this.numberErrors = this.targetPER*ones(size(this.numberObservations));
        end
        
        %From the observations in numberErros and numberObservations,
        %generates the optimum probability distribution for the mcs.
        function p = probabilityLA(this)
           p = zeros(size(this.numberObservations));
           pErr = StatAckLinkAdap.calculateErrorProb(this.numberErrors,this.numberObservations);
           tput = zeros(size(pErr));
           for in=1:length(tput)
              tput(in) = (1-pErr(in))*this.mcsSet(in).rate;
           end
           if min(pErr) > 0.1
               p(1) = 1;    %If the problem is not feasible, we exit
           else
               options=optimset('Display', 'off');
               p = linprog(-tput, pErr, this.targetPER, ones(size(tput)),1,zeros(size(p)),ones(size(p)),[],options);
           end           
           p = p/sum(p);
        end
    end    
    
    methods(Static)
        %Generates a sample of RV with P(real = val(i)) = p(i)
        function realization = generateDiscreteRV(p,val)
            P = zeros(size(p));
            for in=1:size(p)
               P(in) = sum(p(1:(in-1))); 
            end
            r = rand(1);
            realization = val(1);
            for in=1:size(p)
                if r>P(in)
                    realization = val(in);
                end
            end
        end
        
        %Function that calculates the error probabilities assuming 
        function p = calculateErrorProb(numErrors,numTot)
            %Initialize groups
            groups = {};
            for in=1:length(numErrors)
               groups(in) = {in};
            end            
            %Start iteration 
            fin = 0;
            while (fin == 0)
                p = zeros(size(numTot));
               %Calculate propabilities
               for in=1:length(numErrors)
                  indices = cell2mat(groups(in));
                   p(in) = sum(numErrors(indices)) / sum(numTot(indices));
               end
               %See if the probabilities are in decreasing order
               fin = 1;
               for in=1:(length(numErrors)-1)
                  if p(in) > p(in+1)
                     %Merge groups
                     groups(in) = {unique([cell2mat(groups(in)) cell2mat(groups(in+1))])};
                     groups(in+1) = groups(in);
                     fin = 0;
                     break
                  end
               end
            end
        end
    end
    
    
end

