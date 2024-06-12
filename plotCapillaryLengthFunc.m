function plotCapillaryLengthFunc(dataName,colourFolder,editsFunc,pxGrd,filetype)
    % script to use the images collected from 'collectSurfaceTensionData.m' to
    % plot the skew and capillary length at each angle with errors, then
    % extrapolate to find the capillary length corresponding to a skew of 0,
    % from which our best estimate of surface tension is found
    
    
    
    workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
    checkerFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\'; % folder containing the images of the checkerboards
    refFolder = strcat(workingFolder, "ref\",colourFolder); % folder to save reference images into
    imgFolder = strcat(workingFolder, "images\",colourFolder); % folder to save distorted images into
    
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
    lcDeviations = [];
    angleError = ones(1, length(angleArray)) * 0.088; % based on resolution of rotary encoder
    
    
    for i = 1 : length(angleArray)
        
        angleFolder = strcat(imgFolder, angleArray(i), '\');
        
        disp(strcat("angle :",angleFolder))
    
        imgArray = dir(strcat(angleFolder));
        imgArray = {imgArray.name}; % extract filenames of all images at particular angle
        imgArray = imgArray(3:end);
        
        if editsFunc == "edits"
            [lc, lcArray] = findCapillaryLength_edits(imgArray, angleFolder, cr, cu, pxGrd);  % find capillary lengths from images
        elseif editsFunc == "edits2"
            [lc, lcArray] = findCapillaryLength_edits2(imgArray, angleFolder, cr, cu, pxGrd);  % find capillary lengths from images
        else
            disp("unknown editsFunc, using edits2")
            [lc, lcArray] = findCapillaryLength_edits2(imgArray, angleFolder, cr, cu, pxGrd);  % find capillary lengths from images
            editsFunc="edits2"
        end
        
        lcArrayByAngle(i) = lc;
        lcDeviations(i) = std(lcArray); % find estimate of error in capillary length
        
    end
    
    
    angleArray = str2double(strrep(angleArray, '_', '.')); % converts angle folder names back to numerical angles
    
    
    % plot results and find best estimate of surface tension:
    
    plotFolder = strcat(workingFolder, "plots\",editsFunc,"\",colourFolder);
    mkdir(plotFolder);
    
    
    
    
    figure, plot3 = errorbar(angleArray, lcArrayByAngle, lcDeviations, lcDeviations, angleError, angleError, '.'); % plot skew against angle
    xlabel("Angle / degrees");
    ylabel("Capillary Length / mm");
    title("Capillary length against angle");
    saveas(plot3, strcat(plotFolder, "CapVSAngle.fig"));
    saveas(plot3, strcat(plotFolder, "CapVSAngle.png"));

    sts = (lcArrayByAngle.^2).*(1e-6 * (997.5-1.2) * 9.806) * 1000;

    sts_dev = 2*(lcDeviations./lcArrayByAngle).*sts;
    
    errorbar(angleArray,sts,sts_dev,sts_dev,angleError,angleError,'.')
    title("Surface Tension against razor angle")
    xlabel("degrees")
    ylabel("Surface Pressure / mN/m")
    savefig(strcat(plotFolder,"STvsAngle.fig"))
    
    
    
    
    
    close all
     

end