function [T1,T2,t] = cell_simulator( Ta,Tskin,Rc,R0,Ra,tau,noise_gain,L_init,n0)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   Ta=ambient temperature
%   Tskin=Ultimate value of the skin temperature
%   Rc=core body thermal resistance
%   Ra=housing material thermal resistance
%   tau=housing thermal time constant
%   noise_gain=accuracy of sensor
%   The growth equation is 
  T=Tskin+(Ta-Tskin)*exp(-t/tau)

Tc=Tskin+(Rc/(R0+Ra))*(Tskin-Ta);
t=[0:n0];
T20=Tskin-R0*(Tc-Tskin)/Rc;
T2=T20+(Ta-T20)*exp(-t/tau);
I=(Tc-T2)/(Rc+R0);
T1=T2+I*R0;
T1=[Ta(1)*ones(1,L_init) T1];
T2=[Ta(1)*ones(1,L_init) T2];
noise1=noise_gain*(1-2*rand(1,length(T1)));
T1=T1+noise1;
noise2=noise_gain*(1-2*rand(1,length(T2)));
T2=T2+noise2;
t=0:length(T1)-1;
end