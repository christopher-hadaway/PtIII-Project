% script to display a preview of the images that will be taken, with
% parameters set in 'cameraSettings.m'

[vid, src] = cameraSettings();

castImgToLCD(['4.png']);

preview(vid);

start(vid);

