
clear all;close all
disp(['       ';'NEW RUN'])

#Input parameters
Ta=22;Tskin=35.5;                     #External measurements
Rc=0.3;R0=.6;Ra=5;                     #Model parameters
rc0=Rc/Ra;r00=R0/Ra;

I0=(Tskin-Ta)/(R0+Ra);              #Heat flux
Tc0=Tskin+I0*Rc;                    #Actual Tc for the above conditions and parameters

tau=10;
noise_gain=0.2;L_init=10;
n0=500;

#Run simulator below
[T1,T2,t] = cell_simulator( Ta,Tskin,Rc,R0,Ra,tau,noise_gain,L_init,n0);
figure;hold on;plot(t,T1);grid;plot(t,T2,'r');title('Cell temperatures T1 and T2')

# STEP 1) Estimate attachment instant
d=diff(T1);[A,m]=max(abs(d));          #Attachment instant is m

# STEP 2) Estimate Ta, from T1 and T2 their starting and steady state values
n0=m+140;                              #Wait for m+40 samples
Ta=mean(T2(1:m));                      #Simple estimate of ambient Ta
T10=T1(m+1);T1inf=mean(T1(n0-10:n0));  #Simple estimate T1inf
T20=T2(m);T2inf=mean(T2(n0-10:n0));    #Simple estimate T2inf

# STEP 3) Estimate thermal resistance ratios from the above estimates
r0=(T1inf-Ta)/(T2inf-Ta)-1;                 #Estimate device parameter r0=R0/Ra
rc=(r0/((T10-Ta)/(T2inf-Ta)-r0))-r0;        #Estimate patient parameter rc=Rc/Ra
disp(' ')
disp('Model thermal resistances rc r0 and temperature estimates')
disp('=============================================')
disp(['Actual rc    = ',num2str(rc0),', Estimated rc = ',num2str(rc)])
disp(['Actual r0    = ',num2str(r00),', Estimated r0 = ',num2str(r0)])
disp('   ')

# STEP 4) Estimate Tc_est by combining the results of STEP 2) and STEP 3)
Tc_est=Ta+(1+r0+rc)*(T2inf-Ta);                #Estimate Tc from Ta, T2inf, r0, rc

disp(['Actual Tc0   = ',num2str(Tc0)])
disp(['Estimated Tc = ',num2str(Tc_est)])
# [T1inf0 T1inf;T2inf0 T2inf]


##
# TTc=Ta+(1+r0+rc)*(T2-Ta);                    #Growth model for Tc
# figure;hold on;plot(t,T1);grid;plot(t,T2,'r');plot(t,TTc,'k');
# plot(t,Tc0*ones(size(TTc)),'b-','linewidth',2)
# title('Cell temperatures T1 and T2 and Estimated growth for Tc')
# ##
# # #D=load('data_for_prof.mat');
# # D=load('data_for_prof2.mat');
# # # # #D=load('data_for_prof3_Data50.mat');
# # T_sensor=D.Tskin;Tc=D.Tinf2;Tinf0=mean(T_sensor(end-10:end));
# # T1=T_sensor;T2=T1;
# 
# 
# JUMP=T1(L_INIT+1)-TA;
# TINF=MEAN(T1(END-10:END));T0=T1(L_INIT+1);
# TC=TINF+(RC/(R0+RA))*(TINF-TA);
# RC=RC/RA;R0=R0/RA;
# #  TINF=TINF-1;
# A=[R0 TA-T0;1+R0 TA-TINF];
# Y=[T0*R0;TINF*(1+R0)];
# 
# X=PINV(A)*Y;
# [TC X(1);RC/RA X(2)]