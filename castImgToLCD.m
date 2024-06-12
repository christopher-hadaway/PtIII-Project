
function [] = castImgToLCD(img)
%takes a string filename of a checkerboard image as an argument, then
%displays the checkerboard on the LCD screen

    % screenSizeLCD = [1080 1920]; % pixel dimensions of screen under trough
    % screenSizeLCD = [480 800];

    %folder where the checkerboard images are stored
    checkerfold = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\';


    %returns an array with 1 row for each monitor, each with 4 cells detailing
    %position and size of monitor
    MP = get(0, 'MonitorPositions');


    %checks to see if Matlab can detect 2 monitors
    if size(MP, 1) == 1
        
        disp("Only one monitor detected. Try connecting second monitor and restarting Matlab");

    else
        
        checkerPos = MP(2, 1:2);  % position of second monitor
        
        % puts the figure onto the screen we want it on
        figPos = checkerPos;
        %figPos(1:2)=0;%DISPLAY ON MONITOR 1 troubleshooting
        figPos(3 : 4) = 300;  % this shrinks the figure size so it can squeeze through to the smaller monitor
        fig1 = figure('Position', figPos);
        ax1 = axes(fig1);

        % sets the figure window to full screen mode on the second monitor
        fig1.WindowState = 'fullscreen';
        pause(1);


        % reads the pixel array from checkerboard image and displays it
        [checkerBoard,cmap] = imread(strcat(checkerfold, img));
        %checkerBoard = imread(strcat(checkerfold, img));
        
        % checks the image is in the correct orientation
        if (size(checkerBoard, 1) ~= MP(2, 4))
            if length(size(checkerBoard)) == 2
                checkerBoard = checkerBoard.';
            else
                checkerBoard = permute(checkerBoard,[2,1,3]);
            end
        end
        
        imshow(checkerBoard,cmap);
        %imshow(checkerBoard);

        % remove all the borders and white space
        set(fig1, 'Units', 'pixels');
        set(ax1,'XColor','none')
        set(ax1,'YColor','none')
        set(fig1,'MenuBar','none')
        set(ax1,'DataAspectRatioMode','auto')
        
        % this ensures that the image takes up whole figure
        checkerPos(3 : 4) = 1;  
        set(ax1,'Position', checkerPos)
        
        % sets figure to take up whole screen
        fig1.WindowState = 'fullscreen';

        % ensures the display shows 1:1 cell to pixel
        truesize(fig1);
        drawnow;
    end

end



