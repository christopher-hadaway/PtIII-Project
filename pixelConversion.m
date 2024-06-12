function factor = pixelConversion(cr,cu,gridSize)

    %calculate wavelength of checkerboard perpendicular to the razor-
    %edge (fft finds diagonal wavevectors) 
    %wavelength in units of image pixels
    wavelength = 4* pi/norm(cr.k+cu.k);
    
    %wavelength is 2*gridsize in checkerboard pixels
    %wl = 2*gridSize [chk] = pi/abs(k1+k2) [img]
    %[chk]/[img] = 2 * gridSize / wavelength
    factor = 2 * gridSize / wavelength;
    
end