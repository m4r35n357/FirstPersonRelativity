
#macro ShipClock (Size, X, Y, Z, T, Colour)
    #local Angle = 0.5 * pi * T / T0;
    #local Cos = cos(Angle);
    #local Sin = sin(Angle);
    #local Half = 0.5 * Size;
    #local A = <X + Half * Sin, Y + Half * Cos, Z>;
    #local F = <X - Half * Sin, Y - Half * Cos, Z>;
    sphere { A, 0.05 * Size pigment { colour Colour } }
//    sphere { F, 0.05 * Size pigment { colour White } }
#end

#macro Frame (Size, BlockSize, Z)
    #local Yc = -0.5 * Size;
    #while (Yc <= 0.5 * Size)
        Cube(BlockSize, Size, Yc, Z)
        Cube(BlockSize, -Size, Yc, Z)
        #local Yc = Yc + BlockSize;
     #end
    #local Xc = -Size;
    #while (Xc <= Size)
        #if ((Xc > -Size) & (Xc < Size))
            Cube(BlockSize, Xc, 0.5 * Size, Z)
            #if (Floor < 0)
                Cube(BlockSize, Xc, -0.5 * Size, Z)
            #end
        #end
        #local Xc = Xc + BlockSize;
     #end
#end

// Frames
//CubeRing (2.0, 0.1, 0.0, 0.0, TotalZ + 10.0)
Frame(2.0, 0.1, 0.0)
Frame(2.0, 0.1, 5.0)
Frame(2.0, 0.1, 10.0)
Frame(2.0, 0.1, 15.0)
Frame(2.0, 0.1, 20.0)
//CubeRing (1.0, 0.1, 0.0, 0.0, TotalZ + 0.1)

// Tiles
#macro Tiles (Size, Y, Hue1, Hue2)
    #local Half = 0.5 * Size;
    #local Hue = Hue1;
    #local Zt = 0.0;
    #while (Zt <= TotalZ + 5.0)
        #if (mod(Zt, 1) = 0)
        #if (Hue = Hue1)
            #local Hue = Hue2;
        #else
            #local Hue = Hue1;
        #end
        #end
        #local Xt = - Horizontal + Half;
	#while (Xt <= Horizontal)
            Tile(Size, Xt, Y, Zt + Half, Hue)
            #local Xt = Xt + Size;
        #end
        #local Zt = Zt + Size;
    #end
#end

// Floor/Milestones
#if (Floor > 0)
    Tiles(0.25, -0.5, HOrange, HPaleBlue)
    Milestones(0.0, - 0.05, 0.0, TotalZ + 5.0)
#else
    #local X = Horizontal;
    #while (X >= - Horizontal)
        Milestones(X, - 0.05, 0.0, TotalZ + 5.0)
        #local X = X - 0.1;
    #end
#end

// Clock stations
#local Zc = 0;
#local Xc = -1.0;
#local Yc = 0.0;
#while (Zc <= 20)
    Station(0.25, Xc, Yc, Zc, Time - Delay(Xc, Yc, Zc - dZ))
    #local Zc = Zc + 1;
#end

// Destination
Station(1.0, 0.0, 0.0, TotalZ + 0.6, Time - Delay(0.0, 0.0, TotalZ - dZ))
//Icosohedron(1.0, 0.0, 0.0, TotalZ + 1.5, Time - Delay(0.0, 0.0, TotalZ - dZ))

// Sun
#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
sphere { LorentzZ(X, Y, Z), 10.0 HSLTexture(X, Y, Z, HOrange) }

#if (VisualAids > 0.0)
    // Position indicators
    sphere { LorentzZ(1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.0, 1.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.0, -1.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }
    // Ship clocks
    ShipClock(0.2, -1.5, 0.8, 1.0, Tau, Green)
    ShipClock(0.2, -1.5, 0.8, 1.0, Time, Red)
    ShipClock(0.2, -1.5, 0.8, 1.0, Time - Delay(0.0, 0.0, - dZ), Blue)
    ShipClock(0.2, -1.5, 0.8, 1.0, Time - Delay(0.0, 0.0, TotalZ - dZ), Yellow)
#end

/*
// Grids
//AsteroidGrid(10, 0.0, 0.0, 0.5 * TotalZ)

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
*/

