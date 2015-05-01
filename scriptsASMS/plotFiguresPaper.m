close all

load('experimentITSDual-0.3.mat')
 s_pos = [5 0.45 9.5 1.1];
t_pos = [4 1 6 1.3];
simul.plotTputVsSNR(t_pos,s_pos);
 t_pos = [4 0.09 6 0.11];
 s_pos = [0.5 0.01 7 0.08];
 simul.plotFerVsSNR(t_pos,s_pos);
 
 
 
load('experimentITSDual-3.mat')
 s_pos = [0.2 1.3 4.7 1.95];
t_pos = [4 0.9 6 1.2];
simul.plotTputVsSNR(t_pos,s_pos);
 t_pos = [4 0.009 6 0.02];
 s_pos = [4 0.04 9.5 0.12];
 simul.plotFerVsSNR(t_pos,s_pos);
 
 load('experimentITSDual-15.mat')
 s_pos = [5 0.65 9.7 1.2];
t_pos = [2 0.8 4 1.1];
simul.plotTputVsSNR(t_pos,s_pos);
 t_pos = [4 0.09 6 0.11];
 s_pos = [0.5 0.04 6 0.088];
 simul.plotFerVsSNR(t_pos,s_pos);