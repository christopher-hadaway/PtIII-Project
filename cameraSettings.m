function [vid, src] = cameraSettings()

%grayscale
%vid = videoinput('pointgrey', 1, 'F7_Mono8_1920x1200_Mode0');
vid = videoinput('pointgrey', 1, 'F7_Raw8_1920x1200_Mode0');

%colour
%vid = videoinput('pointgrey', 1, 'F7_BayerRG8_1920x1200_Mode0');

src = getselectedsource(vid);

%camera ROI
% [x_offset y_offset width height]

%480p 4 inch LCD
%vid.ROIPosition = [16 0 928 672];

%OLED 0.39 inch FHD 
vid.ROIPosition = [0 0 1184 1200];

src.Exposure = 2;
%Max Exposure = 2.41;

src.Brightness = 12;
%Max Brightness = 12.48;

src.Shutter = 6;
%Max Shutter = 6.07;

src.Gain = 24;
%Max Gain = 30.00

end