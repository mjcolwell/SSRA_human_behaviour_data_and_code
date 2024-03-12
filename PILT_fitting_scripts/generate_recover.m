clear
close all

load('information.mat');
moddat.information=information;
moddat.trialtype=ones(size(information));
moddat.nochoice=zeros(size(information));
fit_options.trials_to_fit=1;
lrcount=0;

for lr=0.05:0.05:0.95
    lrcount=lrcount+1;
    betacount=0;
    for beta=0.5:2:20
        betacount=betacount+1;
    %generate choice
    bel=[rescorla_wagner(information(1:30),lr,0.5);rescorla_wagner(information(31:60),lr,0.5);rescorla_wagner(information(61:90),lr,0.5)];
    pchoice=1./(1+exp(-beta.*(bel-0.5)));
    for ii=1:20
         moddat.choice=rand(size(pchoice))<pchoice;
         fitdat=fit_q_pram_rewsens(moddat,fit_options);
        llr(ii,1)=fitdat.mean_LR;
        bb(ii,1)=fitdat.mean_rewsens;
    end
     lrout(lrcount,betacount)=mean(llr);
     rewsensout(lrcount,betacount)=mean(bb);
    end

end