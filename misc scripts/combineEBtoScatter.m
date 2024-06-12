
figFolder = "C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\combine_capVSangle_selected\";

saveFolder = "C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\combine_capVSangle_selected\combined\";
mkdir(saveFolder);

figFiles = dir(figFolder);
figFiles = figFiles(4:end);

allX = [];
allYerr = [];
allY = [];

for i = 1:length(figFiles)
    f = openfig(strcat(figFolder,figFiles(i).name));
    eb = findobj(f,'type','ErrorBar');
    X = eb.XData;
    Y = eb.YData;

    allX = horzcat(allX,X);
    allYerr = horzcat(allYerr,eb.YPositiveDelta);
    allY = horzcat(allY,Y);

    close(f);
    clear f;

end

fig = figure();
ax = axes('FontSize',16);
scatter(allX,allY,'MarkerEdgeAlpha',0.3)


binsize = 0.5;
binstart = [0 1 2 3 4 5 6 7 8 9 10 11 12 13]./2 + binsize/2;
bintot = zeros(size(binstart));
bincount = zeros(size(binstart));


for b = 1:length(binstart)
    for d = 1:length(allX)
        if (allX(d)>=(binstart(b)-binsize/2)) && (allX(d) < (binstart(b)+binsize/2))
            bintot(b) = bintot(b) + allY(d);
            bincount(b) = bincount(b)+1;
        end    
    end
end

binavg = zeros(size(binstart));
for b = 1:length(binstart)
    binavg(b) = bintot(b)/bincount(b);
end


hold on
plot(binstart,binavg,'LineWidth',2.4,'DisplayName','mean');
plot([0,7],[2.72,2.72],'LineStyle','--','Color','k','LineWidth',1.6,'DisplayName','Literature value')
hold off


legend('FontSize',18)
xlabel("Razor Angle / degrees",'FontSize',20)
ylabel("Capillary Length / mN/m",'FontSize',20)


selY = [];
selYerr = [];

for i = 1:length(allY)
    if allX(i) > 1.5 && allX(i) < 2.5
        selY = horzcat(selY,allY(i));
        selYerr = horzcat(selYerr,allY(i));

    end
end
stdmean = std(allY,2*allYerr)/sqrt(length(allY))
allmean = mean(allY)

selstdmean = std(selY)/sqrt(length(selY))
selallmean = mean(selY)
