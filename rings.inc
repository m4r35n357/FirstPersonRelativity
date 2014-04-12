
#declare HR = 20.0;
#declare XR = 1.0;
#while (XR < HR)
    Station (0.25, 1.0, -0.5, XR)
    Station (0.25, -0.5, 1.0, XR)
    Station (0.25, 1.0, 0.5, XR)
    Station (0.25, -0.5, -1.0, XR)
    Station (0.25, -1.0, 0.5, XR)
    Station (0.25, 0.5, -1.0, XR)
    Station (0.25, -1.0, -0.5, XR)
    Station (0.25, 0.5, 1.0, XR)
    #declare XR = XR + 1.0;
#end

