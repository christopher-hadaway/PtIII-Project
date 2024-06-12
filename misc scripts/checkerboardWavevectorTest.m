imgfile = "squareboard.png"
imgfolder="C:\Users\Christopher\Documents\NatSci\Year 4\Project\MATLAB\Checkerboards\"

[cr,cu,krad]=findReferenceCarrierPeaks(imgfile,imgfolder);
disp("wavevectors:")
disp(cr.k)
disp(cu.k)
disp("wavenumber (wavevector moduli)")
k1=norm(cr.k);
k2=norm(cu.k);
disp(norm(cr.k))
disp(norm(cu.k))
disp("wavelength = 2pi/k")
disp(2*pi/k1)
disp(2*pi/k2)

kp = norm(cr.k+cu.k)/2; %for this perfect square case, kp is the same as krad! but not in general
lambda = 2*pi/kp;
disp("perendicular wavelength/px")
disp(lambda)
disp(4*pi/norm(cr.k+cu.k))