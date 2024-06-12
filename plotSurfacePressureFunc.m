function plotSurfacePressureFunc(dataName,colourFolder,editsFunc,pxGrd,filetype)
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
    skewArrayByAngle = [];
    lcDeviations = [];
    skewDeviations = [];
    volError = ones(1, length(angleArray)) * 0.02;    
    
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
        try
            [skew, skewArray] = findSkew(imgArray, angleFolder); % find skews from images
        catch
            disp("could not find skew!")
            skew=-1;
            skewArray = [-1];
        end
        lcArrayByAngle(i) = lc;
        skewArrayByAngle(i) = skew;
        lcDeviations(i) = std(lcArray); % find estimate of error in capillary length
        skewDeviations(i) = std(skewArray); % find estimate of error in skew
        
    end
    
    
    angleArray = str2double(strrep(angleArray, '_', '.')); % converts angle folder names back to numerical angles
    
    
    % plot results and find best estimate of surface tension:
    
    plotFolder = strcat(workingFolder, "plots\",editsFunc,"\",colourFolder);
    mkdir(plotFolder);
    

    
    %surface tesnsions in mm
    sts = (lcArrayByAngle.^2).*(1e-6 * (997.5-1.2) * 9.806);
    %surface pressuresin mN/m
    sps = (sts(1)-sts).*1000; 

    sts_dev = 2*(lcDeviations./lcArrayByAngle).*sts;

    sps_dev = 1000*sqrt(sts_dev.^2 + sts_dev(1)^2);
    
    errorbar(angleArray,sps,sps_dev,sps_dev,volError,volError,'.')
    title("Surface Pressure against vol DPPC (1mg/mL) added")
    xlabel("vol DPPC / uL")
    ylabel("Surface Pressure / mN/m")
    savefig(strcat(plotFolder,"SPvsVol.fig"))
    
    
    CONC=0.5;%in mg/mL
    gramsDPPC = ((angleArray.*CONC)./(1000*1000)); %mg to g and uL to mL
    molDPPC = gramsDPPC./734; %M_R(DPPC) = 734
    numDPPC = molDPPC.*(6.023e23); %mol * N_A
    %HARRY MEASURED AREA AS 69.63 cm^2
    areaPerLipid = ((1e16)*(69.63))./numDPPC; %APPROX trough area = 9x9 - 2x4 razor (cm to angstrom)
    
    areaError = (volError./angleArray).* areaPerLipid;
    
    errorbar(areaPerLipid,sps,sps_dev,sps_dev,areaError,areaError,'.');
    title("Surface Pressure against lipid area")
    xlabel("Lipid area / angstrom^2")
    ylabel("Surface Pressure / mN/m")
    savefig(strcat(plotFolder,"SPvsArea.fig"))

    
    
    
    figure, plot3 = errorbar(angleArray, lcArrayByAngle, lcDeviations, lcDeviations, volError, volError, '.'); % plot skew against angle
    xlabel("vol / uL");
    ylabel("Capillary Length / mm");
    title("Capillary length against vol");
    saveas(plot3, strcat(plotFolder, "CapVSVol.fig"));
    saveas(plot3, strcat(plotFolder, "CapVSVol.png"));
    
    
    
    
    
    close all
     

end