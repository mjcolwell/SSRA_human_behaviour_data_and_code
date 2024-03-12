function behdata=lucy_extractc(subject,visnum)

% function to extract ev files from learning task in bupropion study
% usage bupropion_extract_ev(subject_name,visit,run,write_ev)
% subject_name is as used in the output dat file, visit is the study visit
% (1-3), run is the run within the visit (1-2), write_ev determines whether
% ev text files are written or not. Results_dir and ev_dir are optional
% arguements specififying new directories where the log files/ev files are
% stored. behdata is a structure containing the extracted data.


% default location of behavioral data files
dir_name='C:\Users\micha\Desktop\Data\';


%find name
found=0;

dirInfo = dir(fullfile(dir_name, '*.dat')); % Specify the file extension or pattern if needed


% foundlog=0;

for i=1:length(dirInfo)
   % if regexp(a(i).name,[subject,'.*M0',visnum,'.*dat'])
      % disp(a(i).name)
   [subject_extracted, visnum_extracted] = extractValuesFromFileName(dirInfo(i).name);
    if strcmp(subject_extracted, subject) && strcmp(visnum_extracted, visnum)
        found=found+1;
        outnum=i;
    end
%    if regexp(a(i).name,[subject,'.*M0',visnum,'.*log$'])
%        foundlog=foundlog+1;
%        outnuml=i;
        
%    end
    
end

if found>1
   error(['Found ' num2str(found), ' matching result files'])
end

%if foundlog>1
%    error(['Found ' num2str(foundlog), ' matching log files for subject ' subject,' visit ', visnum])
% end

if found==0
    
    sprintf('%s','Found 0 files for; ',subject,' visit ',visnum)
end

%if foundlog==0
    
%    sprintf('%s','Found 0 log files for; ',subject,' visit ',visnum)
%end

%if foundlog==1
%    logdate=NaN;
%    logtime=NaN;
    %[logdate, logtime]=chdrlog([dir_name,a(outnuml).name]);
%else
%    logdate=NaN;
%    logtime=NaN;
%end

if found==1
    fid=fopen([dir_name,dirInfo(outnum).name]);
    
    if fid~=-1
        % this creates a cell array with all the data from the file
        data=[];
        while feof(fid)==0
            data=[data,textscan(fgetl(fid),'%s','delimiter','\t')];
        end
        fclose(fid);
        
%        out.testdate=regexprep(regexprep(a(outnum).name,'.*1721_',''),'_.*','');
%        out.testtime=regexprep(regexprep(a(outnum).name,['.*',out.testdate,'_'],''),'_.*','');
        
%        qq=datetime(out.testdate,'InputFormat','ddMMMyyyy');
%        rr=datetime(out.testtime,'InputFormat','HHmmss');
        
%        if qq~=logdate
%            sprintf('%s','Dates do not match for subject ',subject,' visit ',visnum);
%        end
        
%        if abs(rr-logtime)>duration('01:00:00')
%            sprintf('%s','Times are more than 1 hour apart fors ubject ',subject,' visit ',visnum);
%        end
        
        
    end
    
    
    
    % get header line
    i=1;
    
    while i<size(data,2) && ~strcmp(data{1,i}{1},'run_number')
        i=i+1;
    end
    
    header_row=i;
    
    
    trialnumpos=find(strcmp('trial_number',data{1,i})==1);
    trialtypepos=find(strcmp('trial_type',data{1,i})==1);
    outcometypepos=find(strcmp('outcome_type',data{1,i})==1);
    sidetypepos=find(strcmp('side_type',data{1,i})==1);
    stimonsetpos=find(strcmp('stim_onset',data{1,i})==1);
    choiceonsetpos=find(strcmp('choice_onset',data{1,i})==1);
    intervalonsetpos=find(strcmp('interval_onset',data{1,i})==1);
    outcomeonsetpos=find(strcmp('outcome_onset',data{1,i})==1);
    ITIonsetpos=find(strcmp('ITI_onset',data{1,i})==1);
    sidechoicepos=find(strcmp('side_chosen',data{1,i})==1);
    butpresspos=find(strcmp('button_pressed',data{1,i})==1);
    trialoutcomepos=find(strcmp('trial_outcome',data{1,i})==1);
    totalpos=find(strcmp('total',data{1,i})==1);
    rtpos=find(strcmp('reaction_time',data{1,i})==1);
    winoutpos=find(strcmp('win_out',data{1,i})==1);
    lossoutpos=find(strcmp('loss_out',data{1,i})==1);
    runnumberpos=1;
    
    %extract data
    trialnum=[];
    run_num=[];
    trialtype=[];
    outcometype=[];
    sidetype=[];
    stimonset=[];
    choiceonset=[];
    intervalonset=[];
    butpress=[];
    outcomeonset=[];
    ITIonset=[];
    sidechoice=[];
    trialoutcome=[];
    total=[];
    rt=[];
    winout=[];
    lossout=[];
    
    i=1;
    
    while i<=size(data,2)
        
        % the loss out column is sometimes blank which confuses the search--
        % pad out missing fields at the end of each line.
        
        if length(data{1,i}) <lossoutpos
            for g=length(data{1,i})+1:lossoutpos
                data{1,i}{g}=' ';
            end
        end
        
        
        
        % this ensures the first piece of data is a number (as is the case on
        % the trial rows)
        if i>header_row && ~isempty(str2num(data{1,i}{1}))
            run_num=[run_num;str2num(data{1,i}{runnumberpos})];
            trialnum=[trialnum;str2num(data{1,i}{trialnumpos})];
            trialtype=[trialtype;str2num(data{1,i}{trialtypepos})];
            outcometype=[outcometype;str2num(data{1,i}{outcometypepos})];
            sidetype=[sidetype;str2num(data{1,i}{sidetypepos})];
            stimonset=[stimonset;str2num(data{1,i}{stimonsetpos})];
            choiceonset=[choiceonset;str2num(data{1,i}{choiceonsetpos})];
            intervalonset=[intervalonset;str2num(data{1,i}{intervalonsetpos})];
            outcomeonset=[outcomeonset;str2num(data{1,i}{outcomeonsetpos})];
            ITIonset=[ITIonset;str2num(data{1,i}{ITIonsetpos})];
            butpress=[butpress;str2num(data{1,i}{butpresspos})];
            sidechoice=[sidechoice;str2num(data{1,i}{sidechoicepos})];
            trialoutcome=[trialoutcome;str2num(data{1,i}{trialoutcomepos})];
            total=[total;str2num(data{1,i}{totalpos})];
            rt=[rt;str2num(data{1,i}{rtpos})];
            
            if trialtype(end)==1
                winout=[winout;str2num(data{1,i}{winoutpos})];
                lossout=[lossout;NaN];
            else
                lossout=[lossout;str2num(data{1,i}{lossoutpos})];
                winout=[winout;NaN];
            end
            
            
            
            
        end
        
        i=i+1;
    end
    
    
    % create structure for processed data
    behdata=struct;
    behdata.session.subject=subject;
    
    behdata.task_structure.trialtype=trialtype;
    behdata.task_structure.runnum=run_num;
    behdata.task_structure.outcometype=outcometype;
    behdata.task_structure.sidetype=sidetype;
    behdata.timing.stimonset=stimonset;
    behdata.timing.choiceonset=choiceonset;
    behdata.timing.intervalonset=intervalonset;
    behdata.timing.outcomeonset=outcomeonset;
    behdata.timing.ITIonset=ITIonset;
    behdata.performance.sidechoice=sidechoice;
    behdata.performance.trialoutcome=trialoutcome;
    behdata.performance.total=total;
    behdata.performance.rt=rt;
    behdata.performance.winout=winout;
    behdata.performance.lossout=lossout;
    behdata.performance.button_pressed=butpress;
    
    save(['C:\Users\micha\Desktop\Test\',subject,'_visit_',visnum,'_behddata.mat'],'behdata');

else
    behdata.missing=1;

end
    
