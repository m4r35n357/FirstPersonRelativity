
#macro Frame (Size, BlockSize, Z)
    #local Yc = -Size;
    #while (Yc <= Size)
        Cube(BlockSize, Size, Yc, Z)
        Cube(BlockSize, -Size, Yc, Z)
        #if ((Yc > -Size) & (Yc < Size))
//            Cube(BlockSize, Yc, -Size, Z)
            Cube(BlockSize, Yc, Size, Z)
        #end
        #local Yc = Yc + BlockSize;
     #end
#end

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
        #local Xt = -2.0 + Half;
	#while (Xt <= 2.0)
            Tile(Size, Xt, Y, Zt + Half, Hue)
            #local Xt = Xt + Size;
        #end
        #local Zt = Zt + Size;
    #end
#end

// Milestones
//#local X = Horizontal;
//#while (X >= - Horizontal)
//    Milestones(X, - 0.05, 0.0, TotalZ + 5.0)
//    #local X = X - 0.1;
//#end
Milestones(0.0, - 0.05, 0.0, TotalZ + 5.0)

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

// Sun
#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
sphere { LorentzZ(X, Y, Z), 10.0 HSLTexture(X, Y, Z, HOrange) }

// Frames
Frame(2.0, 0.1, 0.0)
Frame(2.0, 0.1, 5.0)
Frame(2.0, 0.1, 10.0)
Frame(2.0, 0.1, 15.0)
Frame(2.0, 0.1, 20.0)

// Floor
Tiles(0.25, -0.5, HRed, HBlue)

// Position indicators
sphere { LorentzZ(1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(0.0, 1.0, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(-1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(0.0, -1.0, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(-0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
sphere { LorentzZ(-0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }

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

