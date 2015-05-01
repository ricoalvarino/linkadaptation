classdef SimulMult < handle
    %SIMULMULT Simulates multiple parameters
    
    properties
        paramArray
        stats
        seriesStat
    end
    
    methods
        function o = SimulMult(pArray)
            if nargin > 0
               o.paramArray = pArray; 
            end
        end
        
        %Performs siimulation
        function simul(this, pArray)
            if nargin > 1
               this.paramArray = pArray;
            end
            
            sim = Simulator();
            sim(numel(this.paramArray)) = Simulator();
            
            %Simulate!
            parfor j=1:numel(this.paramArray)
                sim(j) = Simulator();
                sim(j).setParam(this.paramArray(j));
                sim(j).simulate();
            end
            
            this.stats = sim(1).getStats;
            %Save results: initialize and then get statistics
            this.stats(size(this.paramArray,1),size(this.paramArray,2)) = sim(1).getStats;
            for i=1:numel(this.paramArray)
                this.stats(i) = sim(i).getStats();
            end
            
            %Average results if time series required
            if (this.stats(1).saveSeries == 1)
                %Initialize seriesStat
                this.seriesStat = SeriesAggregator();
                this.seriesStat(size(this.paramArray,2)) = SeriesAggregator();
                for column=1:length(this.seriesStat)
                   %We add the simulation results 
                   for row=1:size(this.stats,1)
                        this.seriesStat(column).addSeries(this.stats(row,column));
                   end
                end
            end
        end
        
        %Plot throughput
        function plotTputVsSNR(this,subplots,subplott)
            markers = {'rs','ko','--','-',':','<'};
            x = zeros(size(this.paramArray));
            y = zeros(size(this.paramArray));
            leg = {};
            for i=1:size(this.paramArray,1)
                for j=1:size(this.paramArray,2)
                    x(i,j) = this.paramArray(i,j).channel.snr;
                    y(i,j) = this.stats(i,j).getTput();
                end
            end
            
            for j=1:size(this.paramArray,2)
               leg(j) =  {this.paramArray(1,j).plotTag}; 
            end
            figure
            for j=1:size(this.paramArray,2)
                p = plot(10*log10(x(:,j)),y(:,j),markers{mod(j-1,length(markers))+1});
                set(p,'linewidth',2); 
                set(p,'markersize',10); 
                hold on
            end
            
            ylabel('Spectral Efficiency (b/s/Hz)','interpreter','latex');
            xlabel('SNR (dB)','interpreter','latex');
            %keyboard
            h = legend(leg);
            set(h,'interpreter','latex')            
            
            if nargin > 2
                zoomPlot(gca,subplots,subplott);
            end
            

        end
        
        %Plot FER
        function plotFerVsSNR(this,subplots,subplott)
            markers = {'rs','ko','--','-',':','<'};
            x = zeros(size(this.paramArray));
            y = zeros(size(this.paramArray));
            for i=1:size(this.paramArray,1)
                for j=1:size(this.paramArray,2)
                    x(i,j) = this.paramArray(i,j).channel.snr;
                    y(i,j) = this.stats(i,j).getFer();
                end
            end
            for j=1:size(this.paramArray,2)
               leg(j) =  {this.paramArray(1,j).plotTag}; 
            end
            figure
            for j=1:size(this.paramArray,2)
                p = plot(10*log10(x(:,j)),y(:,j),markers{mod(j-1,length(markers))+1});
                set(p,'linewidth',2);     
                set(p,'markersize',10);
                hold on
            end
           
            ylabel('PER','interpreter','latex');
            xlabel('SNR (dB)','interpreter','latex');
            %keyboard
            h = legend(leg);
            set(h,'interpreter','latex')
            
            if nargin > 2
                zoomPlot(gca,subplots,subplott);
            end
            
        end
        
        
        %Plot Tput Series
        function plotTputSeries(this)
            y = zeros( size(this.paramArray,2), this.paramArray(1).nIter);
            
            for i=1:size(this.paramArray,2)
                y(i,:) = this.seriesStat(i).sTput();                
            end
            for j=1:size(this.paramArray,2)
               leg(j) =  {this.paramArray(1,j).plotTag}; 
            end
            figure
            p = plot(y');
            set(p,'linewidth',2);   
            title('Throughput')
            xlabel('sample')
            %keyboard
            legend(leg);
        end
        
        
        %Plot FER Series
        function plotFerSeries(this)
            y = zeros( size(this.paramArray,2), this.paramArray(1).nIter);
            
            for i=1:size(this.paramArray,2)
                y(i,:) = this.seriesStat(i).sFer();                
            end
            for j=1:size(this.paramArray,2)
               leg(j) =  {this.paramArray(1,j).plotTag}; 
            end
            figure
            p = plot(y');
            set(p,'linewidth',2);   
            title('FER')
            xlabel('sample')
            %keyboard
            legend(leg);
        end
        
        
        %Plot cumulative FER
        function plotCumulativeFer(this)
            y = zeros( numel(this.paramArray), this.paramArray(1).nIter);
            for j=1:numel(this.paramArray)
               leg(j) =  {this.paramArray(j).plotTag}; 
            end
            for i=1:numel(this.paramArray)
                y(i,:) = 1-cummean(this.stats(i).seriesOK);
            end
            p = plot(y');
            set(p,'linewidth',2);   
            title('FER')
            xlabel('sample')
            %keyboard
            legend(leg); 
            
            
        end
        
        
        
        
        
        
       
            
            
    end
    
end

