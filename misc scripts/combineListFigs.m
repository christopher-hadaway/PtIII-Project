%combine rgb plots into one figure
%capillary vs angle

extensionFolders = ["run64_DPPC_FHD_0_88deg\18FHD"...
                    "run64_DPPC_FHD_0_88deg\20FHD"...
                    "run64_DPPC_FHD_0_88deg\21FHD"...
                    "run64_DPPC_FHD_0_88deg\23FHD"...
                    "run64_DPPC_FHD_0_88deg\26FHD"...
                    "run64_DPPC_FHD_0_88deg\28FHD"...
                    "run64_DPPC_FHD_0_88deg\30FHD"...
                    "run64_DPPC_FHD_0_88deg\35FHD"...
                    "run64_DPPC_FHD_0_88deg\40FHD"...
                    "run64_DPPC_FHD_0_88deg\45FHD"...
                    ];
baseFolder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\'; % folder to save all data and plots within

%colours=["red\","green\","blue\"];
%colourRGB = {'b','r','g',[.5 .6 .7],'k',[.8 .2 .6]};
%colourRGB = {[0.1,0.2,0.9],[0.1,0.5,0.7],[0.1,0.5,0.1],[0.3,0.9,0.4],[0.9,0.1,0.2],[0.9,0.5,0.3],[0,0,0]};

colourRGB = {
    hsv2rgb([0, 1, 1])...        % Red
    hsv2rgb([1/8, 1, 1])...       % Orange
    hsv2rgb([2/8, 1, 1])...     % Yellow
    hsv2rgb([3/8, 1, 1])...       % Lime
    hsv2rgb([4/8, 1, 1])...       % Green
    hsv2rgb([5/8, 1, 1])...       % Cyan
    hsv2rgb([6/8, 1, 1])...       % Blue
    hsv2rgb([7/8, 1, 1])        % Magenta
};



f = figure();
ax=axes();

YDataForMean=[];
XDataForMean=[];
hold on
for i=1:length(extensionFolders)
    
    fig = openfig(strcat(baseFolder,extensionFolders(i),"\plots\edits2\","SPvsArea.fig"));
    
    axObjs = fig.Children;
    dataObjs = axObjs.Children;
    errorbarObj = findobj(dataObjs,'type','ErrorBar');
    


    




    %to correct for capvsangle plotted instead of sp vs lipid area

    %surface tesnsions in mm
    % sts = (errorbarObj.YData.^2).*(1e-6 * (997.5-1.2) * 9.806);
    %surface pressuresin mN/m
    % sps = (sts(1)-sts).*1000; 
    % sps_dev = 2*(errorbarObj.YPositiveDelta./errorbarObj.YData).*sps;
    % 
    % gramsDPPC = (errorbarObj.XData./(1000*1000)); %mg to g and uL to mL
    % molDPPC = gramsDPPC./734; %M_R(DPPC) = 734
    % numDPPC = molDPPC.*(6.023e23); %mol * N_A
    % 
    % %HARRY MEASURED AREA AS 69.63 cm^2
    % 
    % areaPerLipid = ((1e16)*(69.63))./numDPPC; %APPROX trough area = 9x9 - 2x4 razor (cm to angstrom)
    % volError = ones(1, length(errorbarObj.XData)) * 0.5;
    % areaError = (volError./errorbarObj.XData).* areaPerLipid;
    
    disp(i)
    colorLength = length(colourRGB);
    errorbarObj.Color = colourRGB{mod(i-1,colorLength)+1};

    %correct sp vs cap
    % errorbarObj.XData = areaPerLipid;
    % errorbarObj.YData = sps;
    % errorbarObj.YPositiveDelta = sps_dev;
    % errorbarObj.YNegativeDelta = sps_dev;
    % errorbarObj.XPositiveDelta = areaError;
    % errorbarObj.XNegativeDelta = areaError;


    YDataForMean(i,:)=errorbarObj.YData;
    XDataForMean = errorbarObj.XData;
    copy(errorbarObj,ax);
    %plot(ax,errorbarObj.XData,errorbarObj.YData,'Color',colourRGB{mod(i,6)+1})
    

    close(fig);
    clear fig;
end

hold off



YDataMean = mean(YDataForMean); 
A=[];
A(:,1)=XDataForMean;
A(:,2)=YDataMean;

B = sortrows(A);


hold on
plot(B(:,1),B(:,2),"Color","k");
hold off
%xlabel("volume added / uL")
xlabel("Area per Lipid (Angstrom^2)");
%xlabel("Angle / degrees")
ylabel("Surface Pressure (mN/mm)");
%ylabel("Capillary Length/ mm")
%title("Capillary Length angainst razor angle",'0.39" FHD Display');
title("Surface pressure Isotherm","0.5mg/mL DPPC, 0.39 inch FHD, 0.8 deg razor angle")
%legend(horzcat(extensionFolders, "mean"), 'Location', 'north')
legend( "18","20","21","23","26","28","30","35","40","45", 'Location', 'northeast')
mkdir(strcat(baseFolder,"run64_DPPC_FHD_0_88deg\combine plots"))
savefig(strcat(baseFolder,"run64_DPPC_FHD_0_88deg\combine plots\","spvsarea.fig"));
saveas(f, strcat(baseFolder,"run64_DPPC_FHD_0_88deg\combine plots\","spvsarea.png"));
