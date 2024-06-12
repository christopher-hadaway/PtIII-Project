% script to use the images collected from 'collectSurfaceTensionData.m' to
% plot the skew and capillary length at each angle with errors, then
% extrapolate to find the capillary length corresponding to a skew of 0,
% from which our best estimate of surface tension is found

colourFolder = "";

dataName = 'run6_2pxchecker\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
refFolder = strcat(workingFolder, "ref\",colourFolder); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\",colourFolder); % folder to save distorted images into


% define variables particular to current set up:
%DEPRECATED pxConversion = 198.958%28.4695; % this is 1000 * amount of checkerboard pixels per image pixel
pxGrd = 2; % pixels per checker in each dimension
numImages = 5;
filetype = ".png";

% find the average of the reference images:

refArray = dir(strcat(refFolder, "ref*")); 
refArray = {refArray.name}; % creates array of all ref image names in refFolder

disp("Averaging reference images...");


for j = 1 : length(refArray)
    
    refName = strcat(refFolder, string(refArray(j)));
    refImgData = double(imread(refName));  % reads the image data from the ref image
    
    if (j==1)
        refMatrix = refImgData;
    else
        refMatrix = cat(3, refMatrix, refImgData); % joins 2D image arrays into a 3D array
    end
    
end

refAvg = mean(refMatrix, 3); % finds the average ref image data

imwrite(uint8(refAvg), strcat(refFolder, "refAvg", filetype)); % saves averaged reference image

[cr, cu, krad] = findReferenceCarrierPeaks(strcat("refAvg", filetype), refFolder); % finds carrier peaks from reference image



% finds the capillary lengths and skew of each image:

angleArray = dir(imgFolder);
angleArray = {angleArray.name};
angleArray= angleArray(3:end); % removes unwanted elements at beginning


lcArrayByAngle = [];
skewArrayByAngle = [];
lcDeviations = [];
skewDeviations = [];
angleError = ones(1, length(angleArray)) * 0.088; % based on resolution of rotary encoder
volError = ones(1, length(angleArray)) * 0.5;

for i = 1 : length(angleArray)
    
    angleFolder = strcat(imgFolder, angleArray(i), '\');
    
    disp(strcat("angle :",angleFolder))

    imgArray = dir(strcat(angleFolder));
    imgArray = {imgArray.name}; % extract filenames of all images at particular angle
    imgArray = imgArray(3:end);
    
    [lc, lcArray] = findCapillaryLength_edits2(imgArray, angleFolder, cr, cu, pxGrd);  % find capillary lengths from images
    % [skew, skewArray] = findSkew(imgArray, angleFolder); % find skews from images
    
    lcArrayByAngle(i) = lc;
    % skewArrayByAngle(i) = skew;
    lcDeviations(i) = std(lcArray); % find estimate of error in capillary length
    % skewDeviations(i) = std(skewArray); % find estimate of error in skew
    
end


angleArray = str2double(strrep(angleArray, '_', '.')); % converts angle folder names back to numerical angles


% plot results and find best estimate of surface tension:

plotFolder = strcat(workingFolder, "plots\edits2\",colourFolder);
mkdir(plotFolder);








figure, plot3 = errorbar(angleArray, lcArrayByAngle, lcDeviations, lcDeviations, angleError, angleError, '.'); % plot skew against angle
xlabel("Angle / degrees");
ylabel("Capillary Length / mm");
title("Capillary length against razor angle");
saveas(plot3, strcat(plotFolder, "CapVSAngle.fig"));
saveas(plot3, strcat(plotFolder, "CapVSAngle.png"));





%surface tesnsions in mm
sts = (lcArrayByAngle.^2).*(1e-6 * (997.5-1.2) * 9.806) * 1000;

sts_dev = 2*(lcDeviations./lcArrayByAngle).*sts;

errorbar(angleArray,sts,sts_dev,sts_dev,angleError,angleError,'.')
title("Surface Tension against razor angle")
xlabel("degrees")
ylabel("Surface Pressure / mN/m")
savefig(strcat(plotFolder,"STvsAngle.fig"))

%surface tesnsions in mm
sps = sts(1) - sts;

errorbar(angleArray,sps,sts_dev,sts_dev,angleError,angleError,'.')
title("Surface Pressure against razor angle")
xlabel("degrees")
ylabel("Surface Pressure / mN/m")
savefig(strcat(plotFolder,"SPvsAngle.fig"))

