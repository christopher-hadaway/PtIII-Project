% collect data with different checkerboards
% varies razor angle



% define folders to save particular data into
dataName = 'run67_longlens2\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards





% define variables particular to data you want to collect
minAngle = 0.089; % starting angle for razor blade
maxAngle = 3; % maximum angle the razor will tilt to
deltaAngle = 4*0.088; % increment in razor tilt angle between image capturing
numImages = 5; % number of images to take at each angle, to average over


checkerboardFileNames = ["7FHD.png"...
                         "10FHD.png"...
                         "13FHD.png"...
                         "16FHD.png"...
                         "19FHD.png"...
                         "13r.png"...
                         "13g.png"...
                         "13b.png"...
                         ]; % filename of checkerboard to use in this run
filetype = ".png";



% capture reference images:

castImgToLCD(checkerboardFileNames(1)); % displays checkerboard on LCD screen
ax=gca;
LCDImage = findobj(ax,'type','Image');

checkerboards=zeros(length(checkerboardFileNames),1080,1920,3);% missing ,3 for colour
for i = 1 : length(checkerboardFileNames)
    disp(checkerboardFileNames(i))
    [img,cmap] = imread(strcat(checkerFolder,checkerboardFileNames(i)));
    checkerboards(i,:,:,:) = permute(img,[2,1,3]); %missing ,: for colour
end


pause(3);
disp(strcat("Capturing ", int2str(numImages), " reference images"));

for j = 1 : length(checkerboardFileNames)

    refFolder_checker = strcat(workingFolder,strrep(checkerboardFileNames(j),filetype,""),"\ref\");
    mkdir(refFolder_checker);
    LCDImage.CData = reshape(checkerboards(j,:,:,:),1080,1920,3);% missing ,: and ,3 for colour
    pause(1)

    for i = 1 : numImages
        refName = strcat("refimage", int2str(i), filetype);
        delete(strcat(refFolder_checker, refName)); % deletes existing image of same name
        capture(refName, refFolder_checker); % takes the image and saves it
    end
end



calibrate(); % initialises connection with arduino and sets its zero
angle = minAngle; % angle variable keeps track of the current razor angle; initially it is minAngle

sendSerial(angle, arduino); % go to initial position
pause(60); % allow razor to move and vibrations to settle

% capture images at range of angles:

while (angle < maxAngle)
    
    disp("changing angle...")
    sendSerial(angle, arduino); % tilts razor to current angle
    pause(15); % allow razor to move and vibrations to settle
    disp(strcat("Current angle is ", num2str(angle)));
    
    angleName = strrep(num2str(angle), '.', '_'); % replaces decimal point in angle with underscore for saving, e.g. '4.2' becomes '4_2'
    
    
    disp(strcat("Capturing ", int2str(numImages), " images at angle ", num2str(angle)));
    
    for j = 1 : length(checkerboardFileNames)
        angleFolder = strcat(workingFolder, strrep(checkerboardFileNames(j),filetype,""),"\images\", angleName, '\'); % folder to save images from each angle in
        mkdir(angleFolder);
        LCDImage.CData = reshape(checkerboards(j,:,:,:),1080,1920,3); % missing ,: and ,3
        pause(1)
        for i = 1 : numImages
            
            imgName = strcat("image", int2str(i), filetype);
            capture(imgName, angleFolder);
            
        end
    end
    
    angle = angle + deltaAngle; % increments angle
    
end

disp("Returning razor to level")
sendSerial(0,arduino); %return razor to level for next run
pause(15);
disp("done!")

fclose(arduino);
    
