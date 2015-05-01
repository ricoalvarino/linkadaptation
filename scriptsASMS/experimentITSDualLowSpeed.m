clear all
close all

speed = 0.3;
s = SimulConfiguration();
s.nIter = 60000;
s.snr = logspace(-1,1.5,15);
s.delay = 5;
s.channel = 'DualSat';
pD = ParamDualSat();
pD.addEnvironment('i-tree',1,1,speed); %Env, state, startAt, Speed
s.cwLen = 2700;
s.paramDualSat = pD;



%2nd adaptive: Dual
s.linkAdap = 'Dual';
s.plotTag = 'Hybrid CL/OL';
P = s.createParam()';

%1st adaptive: Margin
s.linkAdap = 'Margin';
s.plotTag = 'Adaptive Margin';
P = [P s.createParam()'];

%1st adaptive: Margin
s.linkAdap = 'Open';
s.plotTag = 'Adaptive Margin Open';
P = [P s.createParam()'];

%1st adaptive: Margin
s.linkAdap = 'Close';
s.plotTag = 'Adaptive Margin Close';
P = [P s.createParam()'];

simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

 
save(sprintf('experimentITSDual-%g',speed));