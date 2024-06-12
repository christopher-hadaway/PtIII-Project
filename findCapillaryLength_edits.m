function [lc_avg, lcArray] = findCapillaryLength_edits(imgArray, folder, cr, cu, pxGrd)
% Takes an array of string filenames of the images to analyse, and a string of the folder they are stored in
% Carrier objects and krad are found from running 'findReferenceCarrierPeaks'
% on a reference image.
% Returns the calculated capillary lengths and average capillary length
    
    num = length(imgArray);
    lcArray = zeros(1, num);  % array to store measured capillary lengths
    
    
    %DEPRECATED 
    %pxmm = pxConversion/ (pxGrd * krad)  % actual checkerBoard pixel to mm conversion
    
    
    initialCoeffs = [1.0,0,-7,0.17,0,0]; % initial start point for fitting
    
    
    for i = 1:num
        
        imgName = imgArray(i);
        disp(strcat("image ",imgName))
        tic

        % first-order solution
        surfexp = fittype('cos(p4)*cos(p3)*(A*exp(((p1*x)+(p2*y))))+sin(p3)*y+sin(p4)*x+C', ...
                            'independent',{'x','y'}, ...
                            'dependent','h');

        
        % reads the image data
        Idef=imread(strcat(folder,imgName));
        if numel(size(Idef)) > 2
            Idef = rgb2gray(Idef);
        end

        % convert images to double to prevent rounding errors    
        Idef = double(Idef); %[SW]
        

        % get displacement field and height profile
        fIdef = fft2(Idef); %[SW]
        [u,v] = fcd_dispfield(fIdef,cr,cu,true); %[SW]  % The phase wrap is important
        
        %DEPRECATED
        %u = u/pxmm;
        %v = v/pxmm;    
        


        % integrates the gradient to find the height (inverse gradient)
        h = invgrad2(-u,-v);%DEPRECATED /(pxmm*5.45); % the '5.45' is some value related to the optical thickness of the device, found by Harry.
        % h = intgrad2(-u,-v,1/pxmm,1/pxmm)/5.45; %SLOWER
        
        
        hmin=min(h,[],"all");
        h=h-hmin;
        hmax=max(h,[],"all");
        h = h/hmax; % normalise h so that max value is 1
        

        % Rearange the data for the reqirements of fit()
        %added /1000 to attempt to make fit work!
        ys = linspace(1,length(h(:,1)),length(h(:,1)))/1000;%/pxmm;
        xs = linspace(length(h(1,:)),1,length(h(1,:)))/1000;%/pxmm;    
        xss = reshape(repmat(xs,length(ys),1),1,[]).';
        yss = repmat(ys(:),length(xs),1);

        % Use one edge to reduce the z offset
        %h = h - mean(h(1:end,1));
        hss = reshape(h,1,[]).';
        
        %[Xmesh,Ymesh] = meshgrid(xs,ys);
        %hmesh = reshape(hss,1050,960);
        
        %mesh(Xmesh(1:20:end,1:20:end),Ymesh(1:20:end,1:20:end),2*hmesh(1:20:end,1:20:end));

        % Perform the surface fitting    
        lowerbounds = [0,-25,-15,-0.5,-2,-1];%[0,-25,0.2,-0.1,-2,-1.5];
        upperbounds = [2,25,0.1,0.5,3.0,1];%[2,10,2.0,0.1,3.0,1];
        
        [surffit,gof] = fit([xss,yss],hss,surfexp','Lower',lowerbounds,'StartPoint', initialCoeffs,'Upper',upperbounds)
        
        
        %plot(surffit,[xss(1:50:end),yss(1:50:end)],hss(1:50:end));%,hss(1:1000:end));%mesh(Xmesh(1:20:end,1:20:end),Ymesh(1:20:end,1:20:end),surffit);
        

        initialCoeffs = coeffvalues(surffit); % updates the starting point for the next run - this speeds up the fitting process
        fittedCoeffs = initialCoeffs; %
        conLim = confint(surffit);

        
        % extracts the coefficients from the fitted curve
        A = fittedCoeffs(1);
        l1 = fittedCoeffs(3);
        l2 = fittedCoeffs(4);
        lc = 1/(l1^2+l2^2)^(1/2);
        errorlc =lc* (abs(conLim(1,3)-l1))/l1;

        toc
        
        lcArray(i) = lc;

    end
    %capillary lengths in units of image-pixels
    lcArray = 1000 * lcArray; %x1000 to undo x&y axis scaling applied before fit
    
    %conversion to units of checkerboard-pixels
    lcArray = pixelConversion(cr,cu,pxGrd) * lcArray;
    %conversion to units of millimetres
    %480p
    lcArray = 0.1068 * lcArray; %each pixel is 0.1068 mm (APPROX)
    %1080p
    %lcArray = 0.004557 * lcArray;

    lc_avg = mean(lcArray, 'all') 

end