

#CHECKERBOARD GENERATION
'''
#single colour checkerboards
from PIL import Image

sizes = [5,6,7]
for c in ['r','g','b']:
    for size in sizes:
        img = Image.new('RGB',(1080,1920))

        px = size


        print("generating checkerboard")
        pixels = img.load()
        for i in range(img.size[0]):
            for j in range(img.size[1]):
                x = ((i//px)%2)==0
                y = ((j//px)%2)==0

                col=0
                if x^y:
                    col=255
                r = col * (c=='r')
                g = col * (c=='g')
                b = col * (c=='b')
                
                pixels[i,j] = (r,g,b)
                
                

        print("saving checkerboard " + c + " " + str(size))
        img.save(str(size)+c+".png","PNG")
        print("done!")

'''

#B&W checkerboards FHD
from PIL import Image

sizes = [2,4,6,10]
for size in sizes:
    img = Image.new('RGB',(1080,2280))

    px = size


    print("generating checkerboard")
    pixels = img.load()
    for i in range(img.size[0]):
        for j in range(img.size[1]):
            x = ((i//px)%2)==0
            
            
            y = ((j//px)%2)==0
            
            r=0
            if x^y:
                r=255
            
            pixels[i,j] = (r,r,r)
            
            

    print("saving BW checkerboard pixel size: "+str(size))
    img.save(str(size)+"phone.png","PNG")
    print("done!")



'''
#single colour checkerboards
from PIL import Image
img = Image.new('RGB',(480,800))

px = 3


print("generating checkerboard")
pixels = img.load()
for i in range(img.size[0]):
    for j in range(img.size[1]):
        x = ((i//px)%2)==0
        y = ((j//px)%2)==0

        r=0
        if x^y:
            r=127
        
        pixels[i,j] = (0,r,0)
        
        

print("saving checkerboard")
img.save("green_dim_3px.png","PNG")
print("done!")
'''
'''
#RGB diagonal shift, 3px
from PIL import Image
shiftx = [0,0,0,0,1,1,1,1]
shifty = [0,1,2,3,0,1,2,3]
for s in range(8):
    img = Image.new('RGB',(480,800))

    px = 2


    print("generating checkerboard")
    pixels = img.load()
    for i in range(img.size[0]):
        for j in range(img.size[1]):
            x = (((i+shiftx[s])//px)%2)==0
            
            
            y = (((j+shifty[s])//px)%2)==0
            
            r=0
            if x^y:
                r=255
            
            pixels[i,j] = (r,r,r)
            
            

    print("saving checkerboard"+str(s))
    img.save("chk"+str(s)+".png","PNG")
    print("done!")

'''

'''
#RGB different checker sizes
from PIL import Image
img = Image.new('RGB',(480,800))

rpx = 4
gpx = 3
bpx = 2

print("generating checkerboard")
pixels = img.load()
for i in range(img.size[0]):
    for j in range(img.size[1]):
        x5 = ((i//rpx)%2)==0
        x4 = ((i//gpx)%2)==0
        x3 = ((i//bpx)%2)==0
        y5 = ((j//rpx)%2)==0
        y4 = ((j//gpx)%2)==0
        y3 = ((j//bpx)%2)==0
        r,g,b=0,0,0
        if x5^y5:
            r=255
        if x4^y4:
            g=255
        if x3^y3:
            b=255
        pixels[i,j] = (r,g,b)
        
        

print("saving checkerboard")
img.save("rgb432px.png","PNG")
print("done!")
#Fourier visualisation
'''

'''
import numpy as np
import matplotlib.pyplot as plt
from skimage.io import imread
from skimage.filters import window,gaussian
from skimage import img_as_float
from skimage.color import rgb2gray
from scipy.fft import fft2, fftshift

rgbcheckerboard = img_as_float(rgb2gray(imread("croppedrgb.png")))
rgb = img_as_float(rgb2gray(imread("checkerboardrgb.png")))

wimage = gaussian(rgbcheckerboard) * window('hann', rgbcheckerboard.shape)

wrgb = rgb * window('hann', rgb.shape)

wrgb_f = np.abs(fftshift(fft2(wrgb)))

wimage_f = np.abs(fftshift(fft2(wimage)))

plt.imshow(np.log(wimage_f))
plt.show()
plt.imshow(np.log(wrgb_f))
plt.show()




'''





















