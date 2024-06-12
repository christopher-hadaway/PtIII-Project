
imgfolder = "C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\run1\images\2_2\";
reffolder = "C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\run1\ref\";
reffile = "refAvg.pgm";

[cr,cu,krad]=findReferenceCarrierPeaks(reffile,reffolder);

imgArray = dir(strcat(imgfolder));
imgArray = {imgArray.name}; % extract filenames of all images at particular angle
imgArray = imgArray(3:end);

numImages = length(imgArray);

imgX=1050;
imgY=960;
heights = zeros(numImages,imgX,imgY);

for i=1:numImages
    imgName = imgArray(i);

    tic

    % reads the image data
    Idef=imread(strcat(imgfolder,imgName));

    % convert images to double to prevent rounding errors    
    Idef = double(Idef); %[SW]

    % get displacement field and height profile
    fIdef = fft2(Idef); %[SW]
    [u,v] = fcd_dispfield(fIdef,cr,cu,true); %[SW]  % The phase wrap is important

    % integrates the gradient to find the height (inverse gradient)
    h = invgrad2(-u,-v);%DEPRECATED /(pxmm*5.45); % the '5.45' is some value related to the optical thickness of the device, found by Harry.
    % h = intgrad2(-u,-v,1/pxmm,1/pxmm)/5.45; %SLOWER
    
    %for variance, dont normalise!
    %hmax=max(h,[],"all");
    %h = h/hmax; % normalise h so that max value is 1    
    heights(i,:,:) = h;
    toc
end

varheights = var(heights,0,1);
stdheights = sqrt(varheights);
meanheights = mean(heights,1);
fracheights = 1000 * stdheights./abs(meanheights+min(meanheights,[],"all"));
s=size(fracheights);
%imagesc(reshape(fracheights,s(2),s(3)))
imagesc(reshape(varheights,s(2),s(3)))

