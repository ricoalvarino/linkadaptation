clear all
close all
addLog('Starting...');
speed = 0.3;
s = SimulConfiguration();
s.nIter = 30000;
s.snr = logspace(0,1,5);
s.delay = 16;
s.channel = 'DualSat';
pD = ParamDualSat();
pD.addEnvironment('i-tree',1,1,speed); %Env, state, startAt, Speed
s.cwLen = 600;
s.paramDualSat = pD;



%2nd adaptive: Dual
s.linkAdap = 'Dual';
s.plotTag = 'Hybrid CL/OL';
P = s.createParam()';


%1st adaptive: Margin
s.linkAdap = 'Open';
s.plotTag = 'Adaptive Margin Open';
P = [P s.createParam()'];

%1st adaptive: Margin
s.linkAdap = 'Close';
s.plotTag = 'Adaptive Margin Close';
P = [P s.createParam()'];

%1st adaptive: Margin
s.linkAdap = 'ARFMod';
s.plotTag = 'ARF-M';
P = [P s.createParam()'];

simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

 
save(sprintf('experimentITSDual-%g-other',speed));
addLog('Finishing...');