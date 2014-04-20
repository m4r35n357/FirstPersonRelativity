
#declare HR = 25.0;
#declare XR = 0.0;
#while (XR < HR)
    Station (0.2, 1.0, -0.5, XR)
    Station (0.2, -0.5, 1.0, XR)
    Station (0.2, 1.0, 0.5, XR)
    Station (0.2, -0.5, -1.0, XR)
    Station (0.2, -1.0, 0.5, XR)
    Station (0.2, 0.5, -1.0, XR)
    Station (0.2, -1.0, -0.5, XR)
    Station (0.2, 0.5, 1.0, XR)
    #declare XR = XR + 5.0;
#end

