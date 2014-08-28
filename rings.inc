
#declare Size = 0.2;
#declare XR = 0.0;
#while (XR < TotalZ + 5.0)
    Icosohedron(Size, 1.0, -0.5, XR)
    Icosohedron(Size, -0.5, 1.0, XR)
    Icosohedron(Size, 1.0, 0.5, XR)
    Icosohedron(Size, -0.5, -1.0, XR)
    Icosohedron(Size, -1.0, 0.5, XR)
    Icosohedron(Size, 0.5, -1.0, XR)
    Icosohedron(Size, -1.0, -0.5, XR)
    Icosohedron(Size, 0.5, 1.0, XR)
    #declare XR = XR + 10.0;
#end

