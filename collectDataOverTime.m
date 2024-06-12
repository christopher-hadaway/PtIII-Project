%Collect at one angle over a time

interval = 55; %in seconds (note does not include time to capture images)
numIntervals=60; %number of times data collected


% define folders to save particular data into
dataName = 'run37_hour_2px_2_5deg\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
refFolder = strcat(workingFolder, "ref\"); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\"); % folder to save distorted images into

%set to false to start data collection without changing razor angle or retaking ref images
not_skip = true; 
if not_skip
    mkdir(refFolder);
    mkdir(imgFolder);
    
    
    angle = 2.5;
    deltaAngle = 0.3; % increment in razor tilt angle between image capturing
    numImages = 5; % number of images to take at each angle, to average over
    checkerboardToUse = "2.png"; % filename of checkerboard to use in this run
    filetype = ".png";
    
    
    
    % capture reference images:
    
    castImgToLCD(checkerboardToUse); % displays checkerboard on LCD screen
    pause(3);
    
    
    disp(strcat("Capturing ", int2str(numImages), " reference images"));
    
    for i = 1 : numImages
        
        refName = strcat("refimage", int2str(i), filetype);
        delete(strcat(refFolder, refName)); % deletes existing image of same name
        
        capture(refName, refFolder); % takes the image and saves it
        
    end
    
    calibrate(); % initialises connection with arduino and sets its zero
    %slowly increase razor tilt to angle
    numIncrements = 5;
    for i = 1 : numIncrements
        sendSerial(i/numIncrements * angle, arduino);
        pause(10)
    end
    
    
    
    % capture images at range of angles:
    startTime = datetime('now');
    pause(1);

else
    disp("skipped")
end
for minutes_i = 1:numIntervals
    
    timeNow = datetime('now');
    timeName = minutes(diff([startTime,timeNow]));
    timeFolder = strcat(imgFolder, strrep(num2str(timeName),".","_"), '\'); % folder to save images from each angle in
    mkdir(timeFolder);
    
    disp(strcat("Capturing ", int2str(numImages), " images at time "));
    disp(timeNow);
    
    
    for i = 1 : numImages
        
        imgName = strcat("image", int2str(i), filetype);
        capture(imgName, timeFolder);
        
    end
    
    pause(interval) %capturing 10 images takes ~= 5 s  (APPROX)
end

disp("Returning razor to level")
sendSerial(0,arduino); %return razor to level for next run
pause(15);
disp("done!")

fclose(arduino);
    
