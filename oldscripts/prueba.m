clear all
close all

%%%%%%%%%%%%% 0.9 %%%%%%%%%%%%%%%%%%%
s = SimulConfiguration();
s.nIter = 40000;
s.snr = logspace(0,3,15);
s.channel = 'AR1';
s.rhoAR = 0.9;
s.linkAdap = 'ARFMod';
s.plotTag = 'Modified ARF - 0.9';
P = s.createParam()';

%ARF
s.linkAdap = 'ARF';
s.plotTag = 'ARF - 0.9';
P = [P, s.createParam()'];

%Margin
s.linkAdap = 'Margin';
s.plotTag = 'Margin - 0.9';
P = [P, s.createParam()'];

%LMSLinkAdap
s.linkAdap = 'LMSLinkAdap';
s.plotTag = 'LMSLinkAdap - 0.9';
P = [P, s.createParam()'];

%%%%%%%%%%%%% 0.5 %%%%%%%%%%%%%%%%%%%
s.rhoAR = 0.5;
s.linkAdap = 'ARFMod';
s.plotTag = 'Modified ARF - 0.5';
P = [P, s.createParam()'];

%ARF
s.linkAdap = 'ARF';
s.plotTag = 'ARF - 0.5';
P = [P, s.createParam()'];

%Margin
s.linkAdap = 'Margin';
s.plotTag = 'Margin - 0.5';
P = [P, s.createParam()'];

%Margin
s.linkAdap = 'LMSLinkAdap';
s.plotTag = 'LMSLinkAdap - 0.5';
P = [P, s.createParam()'];

%%%%%%%%%%%%% 0.1 %%%%%%%%%%%%%%%%%%%

s.rhoAR = 0.1;
s.linkAdap = 'ARFMod';
s.plotTag = 'Modified ARF - 0.1';
P = [P, s.createParam()'];

%ARF
s.linkAdap = 'ARF';
s.plotTag = 'ARF - 0.1';
P = [P, s.createParam()'];

%Margin
s.linkAdap = 'Margin';
s.plotTag = 'Margin - 0.1';
P = [P, s.createParam()'];

%Margin
s.linkAdap = 'LMSLinkAdap';
s.plotTag = 'LMSLinkAdap - 0.1';
P = [P, s.createParam()'];


simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

save experimentARDifrho