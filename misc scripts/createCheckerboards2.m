checkerfold = 'C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\';

width = 800;
height = 480;
pxGrd = 6;

board = zeros(width,height);

for i = 1:width
    for j = 1:height
        a=mod(floor((i-1)/pxGrd),2)==0;
        b=mod(floor((j-1)/pxGrd),2)==0;
        if xor(a,b)
            board(i,j)=255;
        end    

    end
end    

% save and show checkerboard
imwrite(board, strcat(checkerfold, "6.png"));
imshow(board);