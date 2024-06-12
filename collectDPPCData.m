%collects data for DPPC
%at one angle
%can use multiple checkerboards
%records volume DPPC added by volume read from syringe

% define folders to save particular data into
dataName = 'run63_DPPC_FHD_0_88deg\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
refFolder = strcat(workingFolder, "ref\"); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\"); % folder to save distorted images into


% define variables particular to data you want to collect
angle = 0.88;
deltaAngle = 0.3; % increment in razor tilt angle between image capturing
numImages = 5; % number of images to take at each angle, to average over

checkerboardFileNames = ["18FHD.png"...
                         "20FHD.png"...
                         "21FHD.png"...
                         "23FHD.png"...
                         "26FHD.png"...
                         "28FHD.png"...
                         "30FHD.png"...
                         "35FHD.png"...
                         "40FHD.png"...
                         "45FHD.png"]; % filename of checkerboard to use in this run

filetype = ".png";



% capture reference images:
noskip = false;

castImgToLCD(checkerboardFileNames(1)); % displays checkerboard on LCD screen
ax=gca;
LCDImage = findobj(ax,'type','Image');

checkerboards=zeros(length(checkerboardFileNames),1080,1920,3);% missing ,3 for colour
for i = 1 : length(checkerboardFileNames)
    disp(checkerboardFileNames(i))
    [img,cmap] = imread(strcat(checkerFolder,checkerboardFileNames(i)));
    checkerboards(i,:,:,:) =  permute(img,[2,1,3]); %missing ,: for colour
end


if noskip
    %castImgToLCD(checkerboardToUse); % displays checkerboard on LCD screen


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
    
    disp("slowly increasing angle")
    numSteps = 5
    for i = 1:numSteps
        sendSerial(double(i) * angle/double(numSteps),arduino)
        pause(8)
    end
    disp("waiting to settle")
    pause(20)
    disp("done")

% capture images at range of angles:
end

if noskip
    volinp = input("('exit' to exit) volume in syringe (uL):");
    syringeVol = double(volinp);
    initVol = syringeVol;
else
    initvol = input("('exit' to exit) initial volume in syringe (uL):");

    volinp = input("('exit' to exit) current volume in syringe (uL):");

end
while (volinp~=-1)
    
    syringeVol = double(volinp);   
    disp(strcat("current volume added is ", num2str(initVol-syringeVol),"uL"))
    volName = num2str(initVol-syringeVol); % replaces decimal point in angle with underscore for saving, e.g. '4.2' becomes '4_2'

    
    disp(strcat("Capturing ", int2str(numImages), " images at added volume ", num2str(initVol-syringeVol)));
    
    
    

    for j = 1 : length(checkerboardFileNames)
        volFolder_chk = strcat(workingFolder, strrep(checkerboardFileNames(j),filetype,""),"\images\", volName, '\'); % folder to save images from each angle in
        mkdir(volFolder_chk);
        LCDImage.CData = reshape(checkerboards(j,:,:,:),1080,1920,3); % missing ,: and ,3
        pause(1)
        for i = 1 : numImages
            
            imgName = strcat("image", int2str(i), filetype);
            capture(imgName, volFolder_chk);
            
        end
    end

   % if initVol-syringeVol == 0
    %    [cr,cu,krad] = findReferenceCarrierPeaks("refimage1.png",refFolder);
    %    [lc_approx,lc_] = findCapillaryLength_edits2(["image1.png"],volFolder,cr,cu,3); % last argument is checkerboard px
     %   disp(strcat("approx capillary length: ",num2str(lc_approx)))
    %end
    
    volinp = input("('-1' to exit) volume in syringe (uL):");
    pause(100)
end

% disp("Returning razor to level")
% sendSerial(0,arduino); %return razor to level for next run
% pause(15);
% disp("done!")

fclose(arduino);
    
