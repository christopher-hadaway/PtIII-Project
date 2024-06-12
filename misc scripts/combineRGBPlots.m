%combine rgb plots into one figure
%capillary vs angle

dataName = 'run25_multiple\rgb432px\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
plotFolder = strcat(workingFolder, "plots\edits2\"); % folder to save reference images into

colours=["red\","green\","blue\"];
colourRGB = [0.74,0.3,0.2;0.3,0.74,0.2;0.2,0.3,0.74];
rgbPlotObjs=[];
f = figure();
ax=axes();

YDataForMean=[];
XDataForMean=[];
for colour_i=1:3
    colourFolder = strcat(plotFolder,colours(colour_i));
    fig = openfig(strcat(colourFolder,"CapVSAngle.fig"));
    
    axObjs = fig.Children;
    dataObjs = axObjs.Children;
    errorbarObj = findobj(dataObjs,'type','ErrorBar');
    errorbarObj.Color = colourRGB(colour_i,:);

    YDataForMean(colour_i,:)=errorbarObj.YData;
    XDataForMean = errorbarObj.XData;

    disp(errorbarObj.YData);
    copy(errorbarObj,ax);

    close(fig);
    clear fig;
end

YDataMean = mean(YDataForMean); 
hold on
plot(XDataForMean,YDataMean);
hold off
xlabel("Razor Angle / degrees");
ylabel("Capillary Length / mm");
title("Capillary length against razor angle from images taken at a range of angles");
legend("4px red", "3px green","2px blue", "mean", 'Location', 'north')
savefig(strcat(plotFolder,"CapVSAngle_combinedRGB.fig"));
saveas(f, strcat(plotFolder,"CapVSAngle_combinedRGB.png"));
