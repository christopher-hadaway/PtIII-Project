%plots skew against motor steps, starting at ~ 2 degrees below 0 skew
folder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\Skew\'

angleRes = 0.088;  % resolution of rotary encoder/angle measurer
numImages = 10;  % number of images to be taken

imageArray = strings(1, numImages);  % array of image names


castImgToLCD('2.png'); % display checkerboard on LCD


calibrate(); % initialise arduino connection


sendSerial(850,arduino); % go to 2 degrees below "zero skew"
pause(20)

stepSize = 5;

skews = ones(1,40);
errors = zeros(1,40);
steps = ones(1,40);
for i5 = 1:60
    [skew,err] = findAverageSkew(numImages, folder);
    skews(i5) = skew;
    errors(i5) = err;
    steps(i5) = (i5-1)*5;
    sendSerial(1000+stepSize,arduino);
    pause(4);
end

errorbar(steps,skews,errors);
title("skew vs steps above -150 steps ","step size 5");
xlabel("steps");
ylabel("skew");
savefig("C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\Skew\skewVSStepsNarrow.fig")

function [skew_avg,skew_dev] = findAverageSkew(numImages, folder)
% takes a given number of photos and finds average skew
% this function just made code above a lot neater

    imageArray = strings(1, numImages);
    disp("Capturing " + string(numImages) + " images...");
    
    for i = 1:numImages
    % capture photos to find skew from
        
        imageName = strcat('skewimage', int2str(i), ".tiff");
        capture(imageName, folder);
        imageArray(i) = imageName;

    end

    
    [skew, skewArray] = findSkew(imageArray, folder);
    
    skew_avg = skew;
    skew_dev = std(skewArray);

end



    

   
    