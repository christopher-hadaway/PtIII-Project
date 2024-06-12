%NEWTON-RAPHSON

%folder = 'C:\Users\rtebb\Documents\SummerProject\Automation\images\';
folder = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\CapturedImages\'

angle = 0;
angleRes = 0.088;  % resolution of rotary encoder/angle measurer
numImages = 10;  % number of images to be taken
tolerance = 0.005;  % tolerance around target skew allowed
targetSkew = 0;  % skew value we are aiming for
imageArray = strings(1, numImages);  % array of image names


castImgToLCD('2.png'); % display checkerboard on LCD


calibrate(); % initialise arduino connection


targetAngle = findAngleFromSkew(targetSkew);
skew = findAverageSkew(numImages, folder) % finds initial skew
skewError = skew - targetSkew; 
disp("initial skew is: " + skew);


while(abs(skewError) > tolerance)
% repeats process until skew is within tolerance of target angle

    if(abs(skewError) < 0.1)
        % when the error gets small, we switch to moving the razor by steps
        % of the motor as this allows us to move it in smaller increments
        disp("NR METHOD:")
        deltaSteps = 4;
        
        sendSerial(deltaSteps+1000,arduino);
        pause(15)

        skew_1 = findAverageSkew(numImages,folder);
        disp(strcat("skew_1 is ",string(skew_1)))
        if sign(skew_1)*sign(skew) == -1
            disp("go to midpoint:")
            steps = +2 % go to midpoint
        else
            dSkew_dSteps = (skew-skew_1)/deltaSteps
            
            %NR : x_(n+1) = x_n - f(x_n)/f'(x_n)
            steps_old = (-300 * skewError + 1 * sign(-skewError)) + 1000; 
            disp("old steps: " + (steps_old-1000));
            steps = -skew_1 / dSkew_dSteps;
            disp(strcat("nr steps: ",string(steps)))
            if abs(steps)>50
                disp("using old steps")
                steps = steps_old;
            end
        end
        sendSerial(steps+1000, arduino);
        

    else
        
        
        deltaAngle = abs(findAngleFromSkew(skew) - targetAngle); % finds angle difference between current and target angle
        angle = angle + deltaAngle * sign(-skewError); % angle variable keeps track of current angle
        sendSerial(angle, arduino);


    end
    
    
    pause(15);
    
    
    skew = findAverageSkew(numImages, folder);
    disp(strcat("skew_0 is",string(skew)))

    skewError = skew - targetSkew;
    disp("Skew error is: " + skewError);
    

    if(abs(skewError) < tolerance)
        % double checks that the skew is less than the tolerance before
        % ending the program
        disp("verifying");
        skew = findAverageSkew(numImages, folder)
        skewError = skew - targetSkew;

    end
    
    pause(5); % pauses are needed else the motor stops moving (something to do with serial buffer?)
     
end

sendSerial(90, arduino); % this tells the arduino to set its current position to its zero
fclose(arduino);
close all;


function [skew_avg] = findAverageSkew(numImages, folder)
% takes a given number of photos and finds average skew
% this function just made code above a lot neater

    imageArray = strings(1, numImages);
    disp("Capturing " + string(numImages) + " images...");
    
    for i = 1:numImages
    % capture photos to find skew from
        
        imageName = strcat('skewimage', int2str(i), ".tiff");
        capture(imageName, folder);
        imageArray(i) = imageName;

    end

    
    [skew, skewArray] = findSkew(imageArray, folder);
    
    skew_avg = skew;

end


function [angle] = findAngleFromSkew(skew)
% estimates angle of razor from the current skew, this formula was found
% from plotting multiple angles against skew and fitting a curve
% It is not at all perfect, which is why we have to find the zero iteratively


    angle = sinh((skew - 0.02163)/(-0.3681))
    
end
    

   
    