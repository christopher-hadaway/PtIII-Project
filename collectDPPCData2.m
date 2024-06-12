%collects data for DPPC
%at one angle
%can use multiple checkerboards
%records volume DPPC added by volume added from syringe ie. volume of drop
%code to plot surface tension as experiment is run (commented out
%currently)

% define folders to save particular data into
dataName = 'run71_2deg_5mL_replacement\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
refFolder = strcat(workingFolder, "ref\"); % folder to save reference images into
imgFolder = strcat(workingFolder, "images\"); % folder to save distorted images into


% define variables particular to data you want to collect
angle = 2.0;
deltaAngle = 0.3; % increment in razor tilt angle between image capturing
numImages = 5; % number of images to take at each angle, to average over

checkerboardFileNames = ["2.png"...
                         "3.png"]; % filename of checkerboard to use in this run


filetype = ".png";




% capture reference images:
noskip = true;

castImgToLCD(checkerboardFileNames(1)); % displays checkerboard on LCD screen
ax=gca;
LCDImage = findobj(ax,'type','Image');

checkerboards=zeros(length(checkerboardFileNames),480,800);% missing ,3 for colour
for i = 1 : length(checkerboardFileNames)
    disp(checkerboardFileNames(i))
    [img,cmap] = imread(strcat(checkerFolder,checkerboardFileNames(i)));
    %checkerboards(i,:,:,:) =  permute(img,[2,1,3]); %missing ,: for colour
    checkerboards(i,:,:) = img.';
end


STFig = figure();
STax = axes(STFig);
boardToPlot = "2\"
boardToPlotPx=2;

if noskip
    %castImgToLCD(checkerboardToUse); % displays checkerboard on LCD screen


    pause(3);
    disp(strcat("Capturing ", int2str(numImages), " reference images"));
    
    for j = 1 : length(checkerboardFileNames)

        refFolder_checker = strcat(workingFolder,strrep(checkerboardFileNames(j),filetype,""),"\ref\");
        mkdir(refFolder_checker);
        LCDImage.CData = reshape(checkerboards(j,:,:),480,800);% missing ,: and ,3 for colour
        pause(1)
    
        for i = 1 : numImages
            refName = strcat("refimage", int2str(i), filetype);
            delete(strcat(refFolder_checker, refName)); % deletes existing image of same name
            capture(refName, refFolder_checker); % takes the image and saves it
        end
    end
    
    % find the average of the reference images:
    refArray = dir(strcat(workingFolder,boardToPlot, "ref\ref*")); 
    refArray = {refArray.name}; % creates array of all ref image names in refFolder   
    disp("Averaging reference images...");
    for j = 1 : length(refArray)
        refName = strcat(workingFolder,boardToPlot, "ref\", string(refArray(j)));
        refImgData = double(imread(refName));  % reads the image data from the ref image
        if (j==1)
            refMatrix = refImgData;
        else
            refMatrix = cat(3, refMatrix, refImgData); % joins 2D image arrays into a 3D array
        end
    end
    
    refAvg = mean(refMatrix, 3); % finds the average ref image data
    
    imwrite(uint8(refAvg), strcat(workingFolder,boardToPlot, "ref\", "refAvg", filetype)); % saves averaged reference image
    
    
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

end

[cr, cu, krad] = findReferenceCarrierPeaks(strcat("refAvg", filetype), strcat(workingFolder,boardToPlot, "ref\")); % finds carrier peaks from reference image


totalVol = 0;
volinp = 0;
while (volinp~=-1)
    
    addedVol = double(volinp);   
    totalVol = totalVol+addedVol;
    disp(strcat("current volume added is ", num2str(totalVol),"uL"))
    volName = strrep(num2str(totalVol), '.', '_');
    
    disp(strcat("Capturing ", int2str(numImages), " images at added volume ", num2str(totalVol)));
    
    
    

    for j = 1 : length(checkerboardFileNames)
        volFolder_chk = strcat(workingFolder, strrep(checkerboardFileNames(j),filetype,""),"\images\", volName, '\'); % folder to save images from each angle in
        mkdir(volFolder_chk);
        LCDImage.CData = reshape(checkerboards(j,:,:),480,800); % missing ,: and ,3
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
    
    % disp("plotting current point...")
    % 
    % folderToPlot = strcat(workingFolder, boardToPlot,"images\", volName, '\')
    % imgArray = dir(strcat(folderToPlot));
    % imgArray = {imgArray.name}; % extract filenames of all images at particular angle
    % imgArray = imgArray(3:end);
    % [lc, lcArray] = findCapillaryLength_edits2(imgArray, folderToPlot, cr, cu, boardToPlotPx);
    % st = (lc^2)*(1e-6 * (997.5-1.2) * 9.806);
    % hold(STax,'on')
    % scatter(STax,totalVol,lc,'Color','k','Marker','x')
    % hold(STax,'off')
    % 
    % disp("done plotting!")


    volinp = input("('-1' to exit) volume added from syringe (uL):");
    pause(20)
end

% disp("Returning razor to level")
% sendSerial(0,arduino); %return razor to level for next run
% pause(15);
% disp("done!")

fclose(arduino);
    
