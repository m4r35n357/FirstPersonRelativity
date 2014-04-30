
#declare HR = 25.0;
#declare XR = 0.0;
#while (XR < HR)
    Station (0.1, 0.5, -0.5, XR)
    Station (0.1, -0.5, 0.5, XR)
    Station (0.1, 0.5, 0.5, XR)
    Station (0.1, -0.5, -0.5, XR)
    Station (0.1, 0.25, -0.25, XR)
    Station (0.1, -0.25, 0.25, XR)
    Station (0.1, 0.25, 0.25, XR)
    Station (0.1, -0.25, -0.25, XR)
//    Station (0.1, 0.5, -0.25, XR)
//    Station (0.1, -0.25, 0.5, XR)
//    Station (0.1, 0.5, 0.25, XR)
//    Station (0.1, -0.25, -0.5, XR)
//    Station (0.1, -0.5, 0.25, XR)
//    Station (0.1, 0.25, -0.5, XR)
//    Station (0.1, -0.5, -0.25, XR)
//    Station (0.1, 0.25, 0.5, XR)
    #declare XR = XR + 5.0;
#end

