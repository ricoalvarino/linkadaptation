clear all
close all

%%%%%%%%%%%%% 0.9 %%%%%%%%%%%%%%%%%%%
s = SimulConfiguration();
s.nIter = 1000;
s.snr = logspace(3,5,15);
s.channel = 'ITS';
s.targetPer = 1;
s.linkAdap = 'statCQI';
s.plotTag = 'Statistical CQI';

P = s.createParam()';

s.linkAdap = 'Margin';
s.targetPer = 0.1;
s.plotTag = 'Margin - 0.1';
P = [P s.createParam()'];

s.targetPer = 0.2;
s.plotTag = 'Margin - 0.2';
P = [P s.createParam()'];


s.targetPer = 0.4;
s.plotTag = 'Margin - 0.4';
P = [P s.createParam()'];

s.targetPer = 0.6;
s.plotTag = 'Margin - 0.6';
P = [P s.createParam()'];

s.targetPer = 0.8;
s.plotTag = 'Margin - 0.8';
P = [P s.createParam()'];



simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

save experimentDifTargetPER