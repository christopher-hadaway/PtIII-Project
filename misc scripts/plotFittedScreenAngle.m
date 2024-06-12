%This file assumes plotSurfaceTensionData has already been run for the data
%in question

dataName = 'run7_4pxchecker_defocussed\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
refFolder = strcat(workingFolder, "ref\"); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\"); % folder to save distorted images into

pxGrd = 4; % pixels per checker in each dimension
numImages = 5;
filetype = ".png";

[cr, cu, krad] = findReferenceCarrierPeaks(strcat("refAvg", filetype), refFolder); % finds carrier peaks from reference image

angleArray = dir(imgFolder);
angleArray = {angleArray.name};
angleArray= angleArray(3:end); % removes unwanted elements at beginning

angleError = ones(1, length(angleArray)) * 0.088; % based on resolution of rotary encoder
p4ByAngle=[];
p3ByAngle=[];
p3Deviations=[];
p4Deviations=[];

for i = 1 : length(angleArray)
    
    angleFolder = strcat(imgFolder, angleArray(i), '\');
    
    disp(strcat("angle :",angleFolder))

    imgArray = dir(strcat(angleFolder));
    imgArray = {imgArray.name}; % extract filenames of all images at particular angle
    imgArray = imgArray(3:end);
    
    
    [p3,p4,p3Array,p4Array] = findFittedAngles(imgArray, angleFolder, cr, cu, pxGrd);  % find capillary lengths from images
    
    p4ByAngle(i) = p4;
    p3ByAngle(i) = p3;
    p4Deviations(i) = std(p4Array); % find estimate of error in capillary length
    p3Deviations(i) = std(p3Array); % find estimate of error in skew
    
end


angleArray = str2double(strrep(angleArray, '_', '.'));


plotFolder = strcat(workingFolder, "plots\");



figure, plot1 = errorbar(angleArray, p3ByAngle, p3Deviations, p3Deviations, angleError, angleError, '.'); % plot skew against angle
hold on
errorbar(angleArray, p4ByAngle, p4Deviations, p4Deviations, angleError, angleError, '.');
hold off
legend({"x axis","y axis"})
xlabel("Razor Angle / degrees");
ylabel("Fitted Rotation / degrees");
saveas(plot1, strcat(plotFolder, "RotFit.fig"));
saveas(plot1, strcat(plotFolder, "RotFit.png"));
