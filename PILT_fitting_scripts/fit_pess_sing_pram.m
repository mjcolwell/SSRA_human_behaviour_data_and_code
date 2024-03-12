function [fitstats]=fit_pess_sing_pram(behave_data, fit_options)

% fit the simple RL model described by Pessiglone et al. to the learning
% data from the bupropion study.
% The model has two parameters-- learning rate and decision temperature. %
% In the original pessiglone paper these were fit across all trials (and
% all subjects). The current function fits a learning rate and temperature to the subset of trials
% defined by trials_to_fit (which may be 1, 2 or [1 2]) of fit_options. behave_data is the
% structure created by bupropion_extract_ev. Data is fit as per Behrens et
% al 2007-- posterior probabilities of the paramters are calculated using
% Bayes and direct integration.

% in this version the model assumes that if one shape is rewarded/punished
% then the other wasn't (even when not seen).



% Defaults for fitting options
if nargin<2
    fit_options=struct;
end

% fit parameters to wins, losses or both
if ~isfield(fit_options,'trials_to_fit')
    fit_options.trials_to_fit=[1 2];
end

% number of discrete values of LR in the joint distribution
if ~isfield(fit_options,'alphabins')
    fit_options.alphabins=110;
end

% number of discrete values for decision temperature in the joint
% distribution
if ~isfield(fit_options,'betabins')
    fit_options.betabins=100;
end

% concatenate trials and outcomes to use in fit
behave_data.information(behave_data.trialtype==2)=1-behave_data.information(behave_data.trialtype==2);
% NB because there is only one thing to learn, transform the negative trials so that punishments are 0 and lack
% of punishments are 1
if fit_options.trials_to_fit==[1 2] %if this is just 1, it is just fitting wins, if just 2 it's fitting losses, if you like it 
    
    choice=behave_data.choice;
    information=behave_data.information;
    noresponse=behave_data.nochoice;
    newrunind=[1:60:180];  %reduced last value from 180 since I had 2 blocks
else
    choice=behave_data.choice(behave_data.trialtype==fit_options.trials_to_fit);
    noresponse=behave_data.nochoice(behave_data.trialtype==fit_options.trials_to_fit);
    information=behave_data.information(behave_data.trialtype==fit_options.trials_to_fit);
  
     newrunind=[1:30:90]; 
end

ntrials=size(choice,1);

% Sample learning rate in log space
logLR=inv_logit(0.01):(inv_logit(0.99)-inv_logit(0.01))/(fit_options.alphabins-1):inv_logit(0.99);

% Sample decision temperature in log space
%logbeta=log(0.1):(log(50)-log(0.1))/(fit_options.betabins-1):log(50);
logbeta=log(0.1):(log(200)-log(0.1))/(fit_options.betabins-1):log(200);

% run the rescorla wagner model for each LR for all trials (and all
% options)
learn_expec=[];
if fit_options.trials_to_fit==[1 2]
    
    for j=1:length(newrunind)
        for tt=1:2
        for i=1:fit_options.alphabins
            if j<length(newrunind)
                trang=newrunind(j):newrunind(j+1)-1;
            else
                trang=newrunind(j):ntrials;
            end
            tt_use=behave_data.trialtype(trang);
            out_use=information(trang);
            
            new_learn(:,i)=rescorla_wagner(out_use(tt_use==tt),inv_logit(logLR(i),1),0.5);
        end
        learn_expec=[learn_expec; new_learn];
        end
    end
    
else
    
    for j=1:length(newrunind)
        for i=1:fit_options.alphabins
            if j<length(newrunind)
                trang=newrunind(j):newrunind(j+1)-1;
            else
                trang=newrunind(j):ntrials;
            end
            new_learn(:,i)=rescorla_wagner(information(trang),inv_logit(logLR(i),1),0.5);
        end
        learn_expec=[learn_expec; new_learn];
    end
end

% centre the expectancy on 0 giving a range of -0.5 to 0.5
rel_val=(learn_expec-0.5);


% replicate before converting to choice probability
rel_val=repmat(rel_val,[1 1 fit_options.betabins]);


% create representation of decision temperature in same space as above
beta=permute(reshape(repmat(exp(logbeta),[1 ntrials*fit_options.alphabins]),[fit_options.betabins,fit_options.alphabins,ntrials]),[3 2 1]);

% calculate choice probability (of choosing the most predictive stimuli
% regardless of winning or loosing trial)
choice_prob=1./(1+exp(-beta.*rel_val));

%represent participant choice on each trial (i.e. best chosen?) in same
%space
best_choice=repmat(choice,[1 fit_options.alphabins fit_options.betabins]);

%likelihood of choices, given parameters
probch=((best_choice.*choice_prob)+((1-best_choice).*(1-choice_prob)));
probch=probch(~noresponse,:,:);

% marginalise over trials in a manner which avoids underflow
qq=probch(1,:,:)./(squeeze(sum(sum(probch(1,:,:),2),3)));
for trial_count=2:size(probch,1)
    qq=qq.*probch(trial_count,:,:);
    qq=qq./squeeze(sum(sum(qq,2),3));
end
pcht=squeeze(qq);


% for normalisation
tot_post=sum(sum(pcht));
fitstats=struct;
% marginal LR
fitstats.marg_LR=(squeeze(sum(pcht,2)./tot_post));
%expected value of LR
fitstats.mean_LR=inv_logit(logLR*fitstats.marg_LR,1);
% variance of LR
fitstats.var_LR=inv_logit(((logLR-inv_logit(fitstats.mean_LR)).^2)*fitstats.marg_LR,1);

% marginal beta
fitstats.marg_beta=squeeze(sum(pcht,1)./repmat(tot_post,length(i),1))';
%expected value of beta
fitstats.mean_beta=exp(logbeta*fitstats.marg_beta);
% variance of beta
fitstats.var_beta=exp(((logbeta-log(fitstats.mean_beta)).^2)*fitstats.marg_beta);
mod_expec=[];
%model predictions
for j=1:length(newrunind)
    
    if j<length(newrunind)
        trang=newrunind(j):newrunind(j+1)-1;
    else
        trang=newrunind(j):ntrials;
    end
    mod_learn(:,1)=rescorla_wagner(information(trang),fitstats.mean_LR ,0.5);
    mod_expec=[mod_expec; mod_learn];
end
% relative value of two options
mod_rel_val=2*(mod_expec-0.5);
mod_choice_prob=1./(1+exp(-fitstats.mean_beta.*mod_rel_val));
mod_likelihood=((choice.*mod_choice_prob)+((1-choice).*(1-mod_choice_prob)));
mod_likelihood=mod_likelihood(~noresponse);
mod_likelihood=mod_likelihood./sum(mod_likelihood);
mod_negLL=-(sum(log(mod_likelihood)));

fitstats.mod_negLL=mod_negLL;
fitstats.mod_rel_val=mod_rel_val;
fitstats.mod_choice_prob=mod_choice_prob;
fitstats.mod_likelihood=mod_likelihood;
fitstats.mod_expec=mod_expec;
fitstats.LR_points=exp(logLR);
fitstats.beta_points=exp(logbeta);
fitstats.posteriorprob=(pcht./tot_post);
fitstats.pcht=pcht;
fitstats.probch=probch;
fitstats.choice_prob=choice_prob;
fitstats.best_choice=best_choice;
fitstats.actchoice=choice;
fitstats.relval=rel_val;
fitstats.learn_expec=learn_expec;
fitstats.choice=choice;
fitstats.information=information;



