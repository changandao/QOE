function data = normalization(rowdata)

[n,p] = size(rowdata);
meanof = mean(rowdata);
stdof = std(rowdata);
meanM = ones(n,1)*meanof;
stdM = ones(n,1)*stdof;

data = (rowdata - meanM)./stdM;

end