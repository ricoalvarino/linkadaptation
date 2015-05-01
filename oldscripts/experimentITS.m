clear all
close all


s = SimulConfiguration();
s.nIter = 40000;
s.snr = logspace(1,4,15);
s.channel = 'DualSat';
s.linkAdap = 'Margin';
s.plotTag = 'Adaptive Margin';

P = s.createParam()';

s.linkAdap = 'Dual';
s.plotTag = 'Hybrid CL/OL';
P = [P s.createParam()'];

s.linkAdap = 'MarginMod';
s.plotTag = 'Adap. Filter';
P = [P s.createParam()'];



simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

save experimentITS