// Milestones
#local X = Horizontal;
#while (X >= - Horizontal)
    Milestones(X, - 0.05, 0.0, TotalZ + 5.0)
    #local X = X - 0.25;
#end

// Grids
AsteroidGrid(10, 0.0, 0.0, 0.5 * TotalZ)

// Rings
#local Size = 0.1;
#local Zr = 0.0;
#while (Zr < TotalZ + 5.0)
    Icosohedron(Size, 1.0, -0.5, Zr)
    Icosohedron(Size, -0.5, 1.0, Zr)
    Icosohedron(Size, 1.0, 0.5, Zr)
    Icosohedron(Size, -0.5, -1.0, Zr)
    Icosohedron(Size, -1.0, 0.5, Zr)
    Icosohedron(Size, 0.5, -1.0, Zr)
    Icosohedron(Size, -1.0, -0.5, Zr)
    Icosohedron(Size, 0.5, 1.0, Zr)
    #local Zr = Zr + 10.0;
#end

// Clock stations
#local Zc = 0;
#while (Zc <= 20)
    Station(0.25, -1.0, 0.0, Zc)
    #local Zc = Zc + 2;
#end

// Destination
Station(1.0, 0.0, 0.0, TotalZ + 0.6)

// Sun
#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
#local SunZ = LorentzZ(X, Y, Z);
light_source { SunZ colour White shadowless }
sphere { SunZ, 10.0 HSLTexture(X, Y, Z, HOrange) }

// Moon
#local X = 0.3;
#local Y = 0.3;
#local Z = TotalZ + 0.5;
sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HLime) }

