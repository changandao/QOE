function [PCRrp,PCRrs,PCRrmse,PLSrp, PLSrs, PLSrmse,vmafrp,vmafrs,...
    vmafrmse,bestmodel] = getMetrics(newdata,labels,vmaf,dataID,pcofPCR,pcofPLS)%,c)

[num, p] = size(newdata);
PCRrmse = 0;
PLSrmse = 0;
PCRrp   = 0;
PCRrs   = 0;
PLSrp   = 0;
PLSrs   = 0;
vmafrp  = 0;
vmafrs  = 0;
vmafrmse = 0;

betapls = 0;
betapcr = 0;

for id = 1:9
    [traindata, trainlabels, testdata, testlabels,trainvmaf,...
        testvmaf] = crossvsal(newdata,labels,vmaf,dataID,id);
    
    %% traning
    X = traindata;
    y = trainlabels;
    [n, p] = size(X);
    
    % training for PLSR
    [Xloadings,Yloadings,Xscores,Yscores,betaPLS, PLSPctVar] = plsregress(X,y,pcofPLS);
    %yfitPLS = [ones(n,1) X]*betaPLS;
    betapls = betapls + betaPLS;
    % training for PCR
    [PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
    betaPCR = regress(y-mean(y), PCAScores(:,1:pcofPCR));
    
    betaPCR = PCALoadings(:,1:pcofPCR)*betaPCR;
    betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
    %yfitPCR = [ones(n,1) X]*betaPCR;
    betapcr = betapcr + betaPCR;
    
    %% testing
    testX = testdata;
    testy = testlabels;
    [testn,testp] = size(testdata);
    
    testyfitPLS = [ones(testn,1) testX]*betaPLS;
    testyfitPCR = [ones(testn,1) testX]*betaPCR;
    
    %% metris
    PCRrmse = PCRrmse + sqrt(sum(testy - testyfitPCR).^2/length(testy));
    PLSrmse = PLSrmse + sqrt(sum(testy - testyfitPLS).^2/length(testy));
    PCRrp = PCRrp + corr(testy,testyfitPCR,'type','pearson');
    PCRrs = PCRrs + corr(testy,testyfitPCR,'type','spearman');
    PLSrp = PLSrp + corr(testy,testyfitPLS,'type','pearson');
    PLSrs = PLSrs + corr(testy,testyfitPLS,'type','spearman');
    vmafrp = vmafrp + corr(testy,testvmaf,'type','pearson');
    vmafrs = vmafrs + corr(testy,testvmaf,'type','spearman');
    vmafrmse = vmafrmse + sqrt(sum(testy - testvmaf).^2/length(testy));

end
betapls = betapls/9;
betapcr = betapcr/9;

PCRrmse = PCRrmse / 9;
PLSrmse = PLSrmse / 9;
PCRrp   = PCRrp / 9;
PCRrs   = PCRrs / 9;
PLSrp   = PLSrp / 9;
PLSrs   = PLSrs / 9;
vmafrp   = vmafrp / 9;
vmafrs   = vmafrs / 9;
vmafrmse   = vmafrmse / 9;

%% figures
fitlabelPCR = [ones(num,1) newdata]*betapcr;
fitlabelPLS = [ones(num,1) newdata]*betapls;

% fitlabelPCR = postprocess(fitlabelPCR);
% fitlabelPLS = postprocess(fitlabelPLS);


% PCRrmse = sqrt(sum(labels - fitlabelPCR).^2/length(labels));
% PLSrmse = sqrt(sum(labels - fitlabelPLS).^2/length(labels));
% PCRrp = corr(labels,fitlabelPCR,'type','pearson');
% PCRrs = corr(labels,fitlabelPCR,'type','spearman');
% PLSrp = corr(labels,fitlabelPLS,'type','pearson');
% PLSrs = corr(labels,fitlabelPLS,'type','spearman');
% vmafrp = corr(labels,vmaf,'type','pearson');
% vmafrs = corr(labels,vmaf,'type','spearman');
% vmafrmse = sqrt(sum(labels - vmaf).^2/length(labels));


% figure(2)
% plot(y,yfitPLS,'o')%,'color', c(i,:));
% xlabel('Observed Response');
% ylabel('Fitted Response');
% legend('PCR with 2 Components' ,'location','NW');
% hold on
% grid on
figure(1)
titleContent = strcat('PCC:',num2str(PLSrp), '   SRCC:',num2str(PLSrs), '   RMSE:',num2str(PLSrmse));
plot(labels,fitlabelPLS,'bo')%,'color', c(i,:));
title(titleContent);
xlabel('MOS');
ylabel('Predicted MOS');
legend('PLSR','location','NW');
hold on
grid on

figure(2)
titleContent = strcat('PCC:',num2str(PCRrp), '   SRCC:',num2str(PCRrs), '   RMSE:',num2str(PCRrmse));
plot(labels,fitlabelPCR,'r*')%,'color', c(i,:));
title(titleContent);
xlabel('MOS');
ylabel('Predicted MOS');
legend('PCR','location','NW');
hold on
grid on

figure(3)
titleContent = strcat('PCC:',num2str(vmafrp), '   SRCC:',num2str(vmafrs), '   RMSE:',num2str(vmafrmse));
plot(labels,vmaf,'k+')%,'color', c(i,:));
title(titleContent);
xlabel('MOS');
ylabel('Predicted MOS');
legend('vmaf','location','NW');
hold on
grid on

figure(4)
titleContent = strcat('PCC:',num2str(PLSrp),',', num2str(PCRrp),',', num2str(vmafrp), '   SRCC:',num2str(PLSrs),',',num2str(PCRrs),',', num2str(vmafrs), '   RMSE:',num2str(PLSrmse),',',num2str(PCRrmse),',', num2str(vmafrmse));
plot(labels,fitlabelPLS,'bo',labels,fitlabelPCR,'r*',labels,vmaf,'k+')%,'color', c(i,:));
title(titleContent);
xlabel('MOS');
ylabel('Predicted MOS');
legend({'PLSR' 'PCR' 'vmaf'} ,'location','NW');
hold on
grid on

% figure(4)
% plot(testy,testyfitPCR,'o')%,'color', c(i,:));
% xlabel('Observed Response');
% ylabel('Fitted Response');
% legend('test PCR with 2 Components' ,'location','NW');
% hold on
% grid on
% 
prevalidation(newdata, labels);

hold off
end