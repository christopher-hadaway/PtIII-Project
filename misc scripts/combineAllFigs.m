%combine rgb plots into one figure
%capillary vs angle

dataName = 'allCapAngleFigs_edits2\'; % name to identify the particular set of data collected in a particular run
workingFolder = strcat('C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\', dataName); % folder to save all data and plots within
plotFolder = strcat(workingFolder, "combined\"); % folder to save reference images into



YData=[];
XData=[];

figArray = dir(workingFolder);
figArray = {figArray.name}; % extract filenames of all images at particular angle
figArray = figArray(3:end);

for i = 1 : length(figArray)
    
    disp(string(figArray(i)))
    fig = openfig(strcat(workingFolder,string(figArray(i))));
    
    errorbars = findobj(fig,'type','ErrorBar');
    for j = 1 : length(errorbars)
        xs = get(errorbars(j),'XData');
        ys = get(errorbars(j),'YData');
        YData = horzcat(YData,ys);
        XData = horzcat(XData,xs);
    end    
    close(fig);
    clear fig
end


f = figure();
ax=axes();

scatter(XData,YData);

filterY = [];
filterX=[];
count=1;
for i = 1 : length(YData)
    if YData(i)<3.2
        filterY(count)=YData(i);
        filterX(count)=XData(i);
        count=count +1;
    end
end    

hold on

yconst = fittype('A*x + B', ...
                            'independent','x', ...
                            'dependent','y');
ymean=fit(reshape(filterX,[],1),filterY.',yconst,'Lower',[0,0])
plot(ymean)
hold off

