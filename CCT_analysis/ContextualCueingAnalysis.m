clear all; close all; clc

figure 
hold on

cd C:/Users/micha/Desktop/FENCOG_Raw_cleaned_dataset/CCT_data;       % CHANGE PATH ACCORDING TO SESSION!!!  AND FILENAME AT BOTTOM AS WELL!!!
%cd /home/cklinge/Desktop/eeg_data_UCB1/CC/session2;       % CHANGE PATH ACCORDING TO SESSION!!!  AND FILENAME AT BOTTOM AS WELL!!!

sublist = 1:1; % PUT ALL PARTICIPANT NUMBERS HERE (1 group, then the other)
% sublist = [1:2 4:10 12:40]; % CHOOSE THIS INSTEAD OF ABOVE IF YOU WANT TO BE SELECTIVE WITH PARTICIPANTS, e.g. to skip subjects 3 and 11
% sublist = [1:2 4:10 12:40]; placebo

nsub = length(sublist);

rtims = [ ]; % reaction times
accs = [ ];  % accuracy data
    
    
for isub = 1:nsub
    
    subfile = sprintf('106.mat',sublist(isub));
    % subfile = [num2str(isub,'%02i') '.mat'];
    
    load(subfile)
    nTrials = 48;
    blocks  = 1:4;
    blockid = reshape(repmat(blocks,[nTrials 1]),[],1);
    
    resp = cat(1,response(blocks).resp);
    accr = cat(1,response(blocks).corr);
    rtim = cat(1,response(blocks).time);
    repeat = cat(1,sequence(blocks).repeatd);
    stimlocat = cat(1,sequence(blocks).stimloc);
    responsetype = cat(1,sequence(blocks).rsptype);
    targeloc = cat(1,sequence(blocks).targloc);
    distloca = cat(1,sequence(blocks).distloc);
    randiti = cat(1,sequence(blocks).iti);

    writematrix([blockid resp accr rtim repeat stimlocat responsetype targeloc distloca randiti],'1.txt', 'Delimiter','tab')

    
    for iblock = blocks
        iitrl = accr == 1 & blockid == iblock & repeat == 1;
        rtims(isub,iblock,1) = median(rtim(iitrl));
        iitrl = accr == 1 & blockid == iblock & repeat == 2;
        rtims(isub,iblock,2) = median(rtim(iitrl));
        
        iitrl = blockid == iblock & repeat == 1;   
        accs(isub,iblock,1) = mean(accr(iitrl));
        iitrl = blockid == iblock & repeat == 2;
        accs(isub,iblock,2) = mean(accr(iitrl));
   
    
    end
    ieff = bsxfun(@minus,rtims,mean(rtims(:,1,:),2));
    %ieff = rtims./accs;
    %%
    subplot(3,nsub,isub+nsub*0)
    plot(squeeze(ieff(isub,:,:)))
    ylim([-0.5 0.5])
    %ylim([0 1])
    
    subplot(3,nsub,isub+nsub*1)
    plot(squeeze(rtims(isub,:,:)))
    ylim([0.4 1])
    
    subplot(3,nsub,isub+nsub*2)
    plot(squeeze(accs(isub,:,:)))
    ylim([0 1])
    
end

%% Plot data for each block
close all
plotval = rtims;
% plotsubs = [1 2 3 4 5 6 7 8]; %this was just me playing around with the pilot data
plotsubs = 1:nsub; % plot average over all subjects
rtmu = squeeze(mean(plotval(plotsubs,:,:),1));
rtsd = squeeze(std(bsxfun(@minus,plotval(plotsubs,:,:),mean(plotval(plotsubs,:,:),3)),[],1));

figure
hold on
hp(1) = errorbar(1:10,rtmu(:,1),-rtsd(:,1),+rtsd(:,1),'g-');
hp(2) = errorbar(1:10,rtmu(:,2),-rtsd(:,2),+rtsd(:,2),'r-');

legend(hp,{'Repeated' 'Unrepeated'}), legend boxoff

%% Plot data in three chunks - 1: 1-3, 2: 4-6, 3: 7-10
close all
tmpdat  = rtims;
if(0)
tmpdat(:,1,:) = mean(tmpdat(:,01:02,:),2);
tmpdat(:,2,:) = mean(tmpdat(:,03:04,:),2);
tmpdat(:,3,:) = mean(tmpdat(:,05:07,:),2);
tmpdat(:,4,:) = mean(tmpdat(:,08:10,:),2);
tmpdat(:,5:end,:) = [];
end
plotval = tmpdat;
% plotsubs = [1 2 3 4 5 6 7 8];
plotsubs = [1:nsub];
rtmu = squeeze(mean(plotval(plotsubs,:,:),1));
rtsd = squeeze(std(bsxfun(@minus,plotval(plotsubs,:,:),mean(plotval(plotsubs,:,:),3)),[],1));

figure
hold on
hp(1) = errorbar(1:size(rtmu,1),rtmu(:,1),-rtsd(:,1),+rtsd(:,1),'g-','linewidth',2,'color',[0.1 0.9 0.1]);
hp(2) = errorbar(1:size(rtmu,1),rtmu(:,2),-rtsd(:,2),+rtsd(:,2),'r-','linewidth',2,'color',[0.3 0.3 0.3]);
set(gca,'Fontname','Arial','fontweight','bold','fontsize',14)
set(gca,'ytick',[0.5:.1:1])
set(gca,'xtick',[1:size(rtmu,1)])
xlabel('Block')
ylabel('Reaction Time (s)')
legend(hp,{'Repeated' 'Unrepeated'}), legend boxoff
xlim([0.5 size(rtmu,1)+0.5])
ylim([0.5 0.8])

d = plotval(plotsubs,:,:);
ndims = size(d);
D = ndims(end:-1:2);
d = reshape(d,[],size(d,2)*size(d,3));
fn = {'Block' 'Repetition'};
alpha = 0.05;
gg = false;
[efs,F,cdfs,p,eps,dfs,b,y2,sig]=repanova(d,D,fn,gg,alpha);	

do_print = 0;
if do_print
   fname = ['/home/cklinge/Desktop/eeg_data/CC/session1/behavplot']; 
   %print(gcf,'-dpng','-adobecset',fname)
   print(gcf,'-depsc2','-adobecset',fname)
end
%%
if(0)
ieff(1,:) = mean(ieff(:,1:3,:),1);
ieff(2,:) = mean(ieff(:,4:6,:),1);
ieff(3,:) = mean(ieff(:,7:10,:),1);
ieff(4:end,:) = [];
end

close all
figure
plot(ieff)

    
