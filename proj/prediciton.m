clear
close all
newpath  = './data/newfeature/';
newFiles = dir([newpath '*.mat']);
LengthFiles = length(newFiles);

c = [];
for i = 0:1
    for Ii = 0:1
        for k = 0:1
            c = [c;[i,Ii,k]];
        end
    end
end
c = [c(1:end-1,:);[0,0.8,0.1];[0.8,0.1,0]];

data = [];
dataID = [];
for i = 1:LengthFiles
    i
    temptnew = newFiles(i);
    new = load([newpath temptnew.name]);
    disp(temptnew.name);
    vmafScore = new.vmafScore;
    newdata = new.new;
    
    newdata = newdata';
    newdata = normalization(newdata);
    ID = ones(size(newdata,1),1) * i;
    
    data = [data; newdata];
    dataID = [dataID; ID];
end
labels = load('./data/label/labels.mat');
labels = labels.labels;
labels = labels';
vmaf = load('./data/vmaf/VMAF_baseline.mat');
vmaf = vmaf.VMAF.all_predictions_merged;
vmaf = vmaf(10:end);

pcofPCR = 6;
pcofPLS = 6;
[PCRrp,PCRrs,PCRrmse,PLSrp, PLSrs, PLSrmse,vmafrp,vmafrs,vmafrmse] = getMetrics(data,labels,vmaf,dataID,pcofPCR,pcofPLS);

