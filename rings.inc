
#declare XR = 0.0;
#while (XR < TotalZ + 5.0)
    Station(0.2, 1.0, -0.5, XR)
    Station(0.2, -0.5, 1.0, XR)
    Station(0.2, 1.0, 0.5, XR)
    Station(0.2, -0.5, -1.0, XR)
    Station(0.2, -1.0, 0.5, XR)
    Station(0.2, 0.5, -1.0, XR)
    Station(0.2, -1.0, -0.5, XR)
    Station(0.2, 0.5, 1.0, XR)
    #declare XR = XR + 10.0;
#end

