%separate a rgb run into 3 colour channels




dataName = 'run27_multiple_shift\rgb3px_shift\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
refFolder = strcat(workingFolder, "ref\"); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\"); % folder to save distorted images into

colourFolder = ["red\","green\","blue\"];

for channel_i = 1:3
        mkdir(strcat(refFolder,colourFolder(channel_i)));
end

filetype = ".png";

% find the average of the reference images:

refArray = dir(strcat(refFolder, "ref*")); 
refArray = {refArray.name}; % creates array of all ref image names in refFolder

disp("Separating reference image RGB channels...");




for j = 1 : length(refArray)
    
    refName = strcat(refFolder, string(refArray(j)));
    refImgData = double(imread(refName));  % reads the image data from the ref image
    for channel_i = 1:3
        imwrite(uint8(refImgData(:,:,channel_i)),strcat(refFolder,colourFolder(channel_i),strrep(string(refArray(j)),".png",".pgm")))

    end
end

for channel_i = 1:3
    mkdir(strcat(imgFolder, colourFolder(channel_i)))
end

angleArray = dir(imgFolder);
angleArray = {angleArray.name};
angleArray= angleArray(3:end); % removes unwanted elements at beginning



for i = 1 : length(angleArray)-3
    for channel_i = 1:3
        angleColourFolder = strcat(imgFolder, colourFolder(channel_i),angleArray(i), '\');
        mkdir(angleColourFolder);
    end   
end

for i = 1 : length(angleArray)-3%dont include red,green,blue folders!
    angleFolder = strcat(imgFolder,angleArray(i), '\');
    disp(strcat("angle :",angleFolder))

    imgArray = dir(strcat(angleFolder));
    imgArray = {imgArray.name}; % extract filenames of all images at particular angle
    imgArray = imgArray(3:end);
    
    for j = 1: length(imgArray) 
        imgData = imread(strcat(angleFolder,imgArray(j)));
        for channel_i = 1:3
            angleColourFolder = strcat(imgFolder, colourFolder(channel_i),angleArray(i), '\');
            imwrite(uint8(imgData(:,:,channel_i)),strcat(angleColourFolder,strrep(imgArray(j),".png",".pgm")))
        end
    end
    
end


 
