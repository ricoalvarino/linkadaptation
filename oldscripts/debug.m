close all
speed = 5;
numCW = 2700;
numTotal = 1000;
pD = ParamDualSat();
pD.addEnvironment('i-tree',1,1,speed);
pD.addEnvironment('i-tree',2,200,speed);
pD.addEnvironment('open',1,400,speed);
pD.addEnvironment('suburban',1,600,speed);
pD.addEnvironment('suburban',2,800,speed);
s.paramDualSat = pD;


chan = DualSatChannel(10, pD, numCW);
chan.init();

m = Mcs(5,inf);
N = 1000;
outputRL = zeros(1,numTotal);
outputFL = outputRL;
for in=1:1000
   outputRL(in) = chan.crossChannel(m,[]);
   outputFL(in) = chan.crossForwardChannel(m,[]);
end

figure, plot(20*log10(abs(chan.logRL)),'r'), hold on, plot(20*log10(abs(chan.logFL)),'b'), plot(20*log10(chan.logLOS),'k')
x = 1:numCW:numTotal*numCW;
plot(x,20*log10(chan.logLOS(x)),'ok')
figure, plot((abs(chan.logRL)),'r'), hold on, plot((abs(chan.logFL)),'b'), plot((chan.logLOS),'k')
figure, plot(outputRL,'r'), hold on, plot(outputFL,'b')

