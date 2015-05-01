clear all
close all


s = SimulConfiguration();
s.nIter = 60000;
s.snr = logspace(0,2,15);
s.delay = 5;
s.channel = 'DualSat';
pD = ParamDualSat();
pD.addEnvironment('i-tree',1,1,10); %Env, state, startAt, Speed
s.cwLen = 2700;
s.paramDualSat = pD;

%1st adaptive: Margin
s.linkAdap = 'Margin';
s.plotTag = 'Adaptive Margin';
P = s.createParam()';

%2nd adaptive: Dual
s.linkAdap = 'Dual';
s.plotTag = 'Hybrid CL/OL';
P = [P s.createParam()'];

simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

save experimentITSDual