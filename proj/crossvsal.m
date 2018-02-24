function [traindata, trainlabels, testdata, testlabels,trainvmaf,testvmaf] = crossvsal(data,labels,vmaf,dataID,id)
% generate dataset for crossvalisation
    traindata = data(dataID~=id,:);
    testdata  = data(dataID==id,:);
    
    trainlabels = labels(dataID~=id);
    testlabels  = labels(dataID==id);
    trainvmaf = vmaf(dataID~=id);
    testvmaf = vmaf(dataID==id);
    
end