sizes = ["1" "2" "4"];
boards = ["FHD.png"];

folder = "C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\OLED 039 FHD test\";

subfolder = "longlens_dust\"
mkdir(strcat(folder,subfolder));

for s = 1 : length(sizes)
    disp(sizes(s))
    for b = 1 : length(boards)
        file = strcat(sizes(s),boards(b));
        castImgToLCD(file);
        pause(2);
        capture(strcat("img",file),strcat(folder,subfolder));
        close all;
    end
end
