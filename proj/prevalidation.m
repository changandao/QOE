function prevalidation(data, labels)
% see the percent variance of PCR and PLSR
    [n,p] = size(data);
    X = data;
    y = labels;
    
    [Xloadings,Yloadings,Xscores,Yscores,betaPLS, PLSPctVar] = plsregress(X,y,p);
    yfitPLS = [ones(n,1) X]*betaPLS;
    %betapls = betapls + betaPLS;
    % training for PCR
    [PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
    betaPCR = regress(y-mean(y), PCAScores(:,1:p));
    
    betaPCR = PCALoadings(:,1:p)*betaPCR;
    betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
    yfitPCR = [ones(n,1) X]*betaPCR;
    %betapcr = betapcr + betaPCR;
    figure(5)
    plot(1:p,cumsum(100*PLSPctVar(2,:)),'-bo',1:p,  ...
    	100*cumsum(PCAVar(1:p))/sum(PCAVar(1:p)),'r-^');
    xlabel('Number of principle components');
    ylabel('Percent Variance Explained in X');
    legend({'PLSR' 'PCR'},'location','SE');
end