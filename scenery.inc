
#macro CubeRing (Radius, Thick, X, Y, Z)
    #local Out = Radius + 0.5 * Thick;
    #local In = Radius - 0.5 * Thick;
    #local Delta = 2.0 * pi / 12.0;
    #local Angle = 0.0;
    #while (Angle < 2.0 * pi)
        #local Sin = sin(Angle);
        #local Cos = cos(Angle);
        #local v1 = LorentzZ(X + In * Sin, Y + In * Cos, Z - 0.5 * Thick);
        #local v2 = LorentzZ(X + Out * Sin, Y + Out * Cos, Z - 0.5 * Thick);
        #local v3 = LorentzZ(X + Out * Sin, Y + Out * Cos, Z + 0.5 * Thick);
        #local v4 = LorentzZ(X + In * Sin, Y + In * Cos, Z + 0.5 * Thick);
        #local SinB = sin(Angle + Delta);
        #local CosB = cos(Angle + Delta);
        #local v5 = LorentzZ(X + In * SinB, Y + In * CosB, Z - 0.5 * Thick);
        #local v6 = LorentzZ(X + Out * SinB, Y + Out * CosB, Z - 0.5 * Thick);
        #local v7 = LorentzZ(X + Out * SinB, Y + Out * CosB, Z + 0.5 * Thick);
        #local v8 = LorentzZ(X + In * SinB, Y + In * CosB, Z + 0.5 * Thick);
        Tiloid (v2, v6, v1, v5, HPaleBlue)
        Tiloid (v3, v7, v4, v8, HViolet)
        Tiloid (v3, v7, v2, v6, HPaleBlue)
        Tiloid (v4, v8, v1, v5, HPaleBlue)
        #local Angle = Angle + Delta;
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

// Frames
//CubeRing (1.0, 0.1, 0.0, 0.0, -0.1)
Frame(2.0, 0.1, 0.0)
Frame(2.0, 0.1, 5.0)
Frame(2.0, 0.1, 10.0)
Frame(2.0, 0.1, 15.0)
Frame(2.0, 0.1, 20.0)
//CubeRing (1.0, 0.1, 0.0, 0.0, TotalZ + 0.1)

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

