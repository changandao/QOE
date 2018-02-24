clear
close all

ssimpath  = './data/ssim/';
vmafpath  = './data/vmaf/';
psnrpath  = './data/psnr/';
newpath   = './data/newfeature/';
labelpath = './data/label/';

ssimFiles  = dir([ssimpath '*.mat']);
vmafFiles  = dir([vmafpath '*.mat']);
psnrFiles  = dir([psnrpath '*.mat']);
labelFiles = dir([labelpath '*.txt']);

LengthFiles = length(ssimFiles);
count = 0;

%labels
fid = fopen([labelpath 'labels.txt']);
tline = str2double(fgetl(fid));
labels = [tline];

while 1
    tline = str2double(fgetl(fid));
    if isnan(tline)
        break
    end
    labels = [labels, tline];
end
disp(labels)
save('./data/label/labels.mat', 'labels')


for i = 1:LengthFiles
    i
    % ssim features
    temptssim = ssimFiles(i);
    ssimname = temptssim.name;
    ssimstruct = load([ssimpath ssimname]);
    disp(temptssim.name)
    singlename = ssimname(1:end-9);
    ssimSGNM = [singlename '_ssim'];
    ssim = ssimstruct.(ssimSGNM);
    
    % vmaf features
    temptvmaf = vmafFiles(i);
    vmafname = temptvmaf.name;
    vmafstruct = load([vmafpath vmafname]);
    disp(temptvmaf.name)
    vmafSGNM = [singlename '_vmaf'];
    vmaf = vmafstruct.(vmafSGNM);
    
    % psnr features 
    temptpsnr = psnrFiles(i);
    psnrname = temptpsnr.name;
    psnrstruct = load([psnrpath psnrname]);
    disp(temptpsnr.name)
    psnrSGNM = [singlename '_psnr'];
    psnr = psnrstruct.(psnrSGNM);
    
    %
    vmafScore = vmaf(7,:);
    new = [vmaf(1:6,:);ssim';psnr'];
    filename = strcat(newpath, singlename, '_new.mat');
    
    save(filename, 'new','vmafScore')
end

