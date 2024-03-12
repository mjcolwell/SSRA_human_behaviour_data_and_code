% wrapper script to run model fits on all participants
clear

% what to call the output file
outbase='chdr_';

%do you want to save all the fit data (will be pretty big)
save_big=1;

%where the results are
base_dir='C:\Users\micha\Desktop\Data\';

%this controls the fitting-- the main things to tweak are:
%1: trials_to_fit. if it is [1 2] it fits one lr and 1 beta to both the win and
%       loss trials. if it is [1] it fits to just wins and [2] to just losses
%2: model_to_use: can be either "pess" or "bal" or "rewsens". 

fitoptions=struct;
fitoptions.trials_to_fit=[1];
fitoptions.model_to_use='fit_pess_sing_pram'; %pess
% rewsens: reward sensitivity and lr
% pess: decision temperature and lr

fitdata=struct;
fitdata.trialtype=[];
fitdata.choice=[];
fitdata.outcome=[];
fitdata.nochoice=[];
fitdata.newrun=[];

%where the behavioral data is
dir_name='C:\Users\micha\Desktop\Data\';

% store subject ids in this list
subjects={};
visitnum={};
%find name of the files
found=0;

dirInfo = dir(fullfile(dir_name, '*.dat')); % Specify the file extension or pattern if needed

%a=dir(dir_name);
%a = {a(~[a.isdir]).name};

% the length of a should be the same length of ALL your data files == 106
for i=1:length(dirInfo)
    name_file = dirInfo(i).name;
    [subject, visnum] = extractValuesFromFileName(name_file);

    subjects{i} = subject;
    visitnum{i} = visnum;
end
subjects = unique(subjects);

for sub=1:size(subjects,2)
    subnum=subjects{sub};
    for vis = 1:size(visitnum, 2)
        v =visitnum{vis};
        if strcmp(v, 'v2')
            visit = 2
        else
            visit = 1
        end

        data=lucy_extractc(num2str(subnum),num2str(v));
        
        
        if ~isfield(data,'missing')
            fitdata.choice=[];
            fitdata.information = [];
            fitdata.outcome=[];
            fitdata.nochoice=[];
            fitdata.nooutcome=[];
            fitdata.newrun=[];
            fitdata.trialtype=[];
            for wl=1:2
                % concatentate data to which parameters will be fitted
                
                % list win trials first then loss trials
                i=1;

                fitdata.trialtype=[fitdata.trialtype; data(1,i).task_structure.trialtype(data(1,i).task_structure.trialtype==wl)];
                nr=zeros(size(data(1,i).task_structure.trialtype(data(1,i).task_structure.trialtype==wl)));
                nr(1)=1;
                nr(find(diff(data.task_structure.runnum(data(1,i).task_structure.trialtype==wl)))+1)=1;
                fitdata.newrun= [fitdata.newrun; nr];
                
                % this codes choice as the choice of the best option
                if wl==1 % win trials
                    fitdata.choice=[fitdata.choice;  double(data(1,i).performance.sidechoice(data(1,i).task_structure.trialtype==wl)==data(1,i).task_structure.sidetype(data(1,i).task_structure.trialtype==wl))];
                elseif wl==2 % loss trials
                    fitdata.choice=[fitdata.choice; 1-double(data(1,i).performance.sidechoice(data(1,i).task_structure.trialtype==wl)==data(1,i).task_structure.sidetype(data(1,i).task_structure.trialtype==wl))];
                end
                fitdata.outcome=[fitdata.outcome;  data(1,i).performance.trialoutcome(data(1,i).task_structure.trialtype==wl)];
                fitdata.information = [fitdata.information;  data(1,i).performance.trialoutcome(data(1,i).task_structure.trialtype==wl)];
                fitdata.nochoice=[fitdata.nochoice; data(1,i).performance.button_pressed(data(1,i).task_structure.trialtype==wl)<0];
 
            end
             %dont fit first trial in each run as random
                fitdata.nochoice(fitdata.newrun==1)=1;
            
            if strcmp(fitoptions.model_to_use,'bal')
                fitstruct=fit_bal(fitdata,fitoptions);
            elseif strcmp(fitoptions.model_to_use,'fit_pess_sing_pram')
                fitstruct=fit_pess_sing_pram(fitdata,fitoptions);
            elseif strcmp(fitoptions.model_to_use,'rewsens')
                fitstruct=fit_q_pram_rewsens(fitdata,fitoptions);
                
            else
                error('model name not recognised')
            end
            
            lr(sub,visit)=fitstruct.mean_LR;
            rho(sub,visit)=fitstruct.mean_rewsens; % for reward senstivity
            %beta(sub,visit) = fitstruct.mean_beta % for pess
            nll(sub,visit)=fitstruct.mod_negLL;
 
            
        else
            lr(sub,visit)=NaN;
            rho(sub,visit)=NaN;
            nll(sub,visit)=NaN;
        end
        subject_data(sub,visit).fitdata=fitdata;
          subject_data(sub,visit).fitstruct=fitstruct;
    end
end

lr=lr;
rho=rho;
%beta=log(beta)
%subgroup=double(subgroup);
out=[rho lr];

if all(fitoptions.trials_to_fit==[1 2])
    outname=[outbase,fitoptions.model_to_use,'_both'];
    
elseif all(fitoptions.trials_to_fit==[1])
    outname=[outbase,fitoptions.model_to_use,'_wins'];
elseif all(fitoptions.trials_to_fit==[2])
    outname=[outbase,fitoptions.model_to_use,'_losses'];
end

if save_big==1

    save([outname,'_big'],'lr','rho','out','nll','subject_data','-v7.3');
else
save(outname,'lr','rho','out','nll');
end



