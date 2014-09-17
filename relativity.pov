#version 3.7;

#declare Red     = rgb <1, 0, 0>;
#declare Green   = rgb <0, 1, 0>;
#declare Blue    = rgb <0, 0, 1>;
#declare Yellow  = rgb <1,1,0>;
#declare Cyan    = rgb <0, 1, 1>;
#declare Magenta = rgb <1, 0, 1>;
#declare Clear   = rgbf 1;
#declare White   = rgb 1;
#declare Black   = rgb 0;
#declare Grey = color red 0.752941 green 0.752941 blue 0.752941;

#macro CH2RGB (HH)
   #local H = mod(HH, 360);
   #local H = (H < 0 ? H+360 : H);
   #switch (H)
      #range (0, 120)
         #local R = (120-  H) / 60;
         #local G = (  H-  0) / 60;
         #local B = 0;
      #break
      #range (120, 240)
         #local R = 0;
         #local G = (240-  H) / 60;
         #local B = (  H-120) / 60;
      #break
      #range (240, 360)
         #local R = (  H-240) / 60;
         #local G = 0;
         #local B = (360-  H) / 60;
      #break
   #end
   <min(R,1), min(G,1), min(B,1)>
#end

#macro CHSL2RGB(Color)
   #local HSLFT = color Color;
   #local H = (HSLFT.red);
   #local S = (HSLFT.green);
   #local L = (HSLFT.blue);
   #local SatRGB = CH2RGB(H);
   #local Col = 2*S*SatRGB + (1-S)*<1,1,1>;
   #if (L<0.5)
      #local RGB = L*Col;
   #else
      #local RGB = (1-L)*Col + (2*L-1)*<1,1,1>;
   #end
   <RGB.red,RGB.green,RGB.blue,(HSLFT.filter),(HSLFT.transmit)>
#end

#if (AccelerationMode > 0.0)
    #declare Z0 = 0.5 * TotalZ;
    #declare Tau0 = acosh(A * Z0 + 1.0) / A;
    #declare T0 = sinh(A * Tau0) / A;
    #declare Tau = 4.0 * Tau0 * clock;
    #if (clock <= 0.25)
        #declare dZ = (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = - tanh(A * Tau);
    #else
        #if (clock <= 0.5)
            #declare Aut = 2.0 * Tau0 - Tau;
            #declare dZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
            #declare Time = 2.0 * T0 - sinh(A * Aut) / A;
            #declare V = - tanh(A * Aut);
        #else
            #if (clock <= 0.75)
                #declare Aut = Tau - 2.0 * Tau0;
                #declare dZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
                #declare Time = 2.0 * T0 + sinh(A * Aut) / A;
                #declare V = tanh(A * Aut);
            #else
                #declare Aut = 4.0 * Tau0 - Tau;
                #declare dZ = (cosh(A * Aut) - 1.0) / A;
                #declare Time = 4.0 * T0 - sinh(A * Aut) / A;
                #declare V = tanh(A * Aut);
            #end
        #end
    #end
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
#else  // constant velocity mode
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
    #if (V > 0.0)
        #declare T0 = TotalZ / V;
        #declare Time = 2.0 * TotalZ / V * clock;
    #else
        #declare T0 = TotalZ;
        #declare Time = 4.0 * T0 * clock;
    #end
    #declare Tau = Time / GAMMA;
    #if (clock <= 0.5)
        #declare dZ = 2.0 * TotalZ * clock;
        #declare V = - V;
    #else 
        #declare dZ = TotalZ - 2.0 * TotalZ * (clock - 0.5);
    #end
#end
#if (Reverse > 0.0)
    #declare dZ = TotalZ - dZ;
    #declare V = -V;
#end

global_settings { assumed_gamma 1.0 }

light_source { <1, 1, 0> colour White shadowless }

camera {
  up <0, 0.9, 0>
  right <1.6, 0, 0>
  location <0.0, 0.0, 0.0>
  angle 120.0
  #if (LookForward > 0.0)
    look_at <0, 0, 1>
  #else  // look left
    look_at <-1, 0, 0>
  #end
}

#declare HRed = 0.0;
#declare HOrange = 30.0;
#declare HYellow = 60.0;
#declare HLime = 90.0;
#declare HGreen = 120.0;
#declare HTurquoise = 150.0;
#declare HCyan = 180.0;
#declare HPaleBlue = 210.0;
#declare HBlue = 240.0;
#declare HViolet = 250.0;

#macro Delay (X, Y, Z)
    sqrt(X * X + Y * Y + Z * Z)
#end

#macro LorentzZ (X, Y, Z)  // Special Relativity happens here . . .
    <X, Y, GAMMA * (Z - dZ - V * Delay(X, Y, Z - dZ))>
#end

#macro LorentzT (X, Y, Z)  // . . . and here!
    GAMMA * (Delay(X, Y, Z - dZ) - V * (Z - dZ))
#end

#macro Doppler (X, Y, Z, Hue)
    #local DF = LorentzT(X, Y, Z) / Delay(X, Y, Z - dZ);
    #if (DF >= 1.0)  // blue shift, lighten
        CHSL2RGB(<250.0 - (250.0 - Hue) / DF, 1.0, 1.0 - 0.5 / DF>)
    #else  // red shift, darken
        CHSL2RGB(<Hue * DF, 1.0, 0.5 * DF>)
    #end
#end

#macro DopplerColour (X, Y, Z, Colour)
    pigment { colour Doppler(X, Y, Z, Colour) }
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { LorentzZ(X, Y, Z), 0.01 DopplerColour(X, Y, Z, HGreen) }
        #else
            sphere { LorentzZ(X, Y, Z), 0.005 DopplerColour(X, Y, Z, HGreen) }
        #end
        #local Z = Z + 1;
    #end
#end

#macro Tiloid (vA, vB, vC, vD, Hue)
  triangle { vA, vB, vD DopplerColour(X, Y, Z, Hue) }
  triangle { vA, vC, vD DopplerColour(X, Y, Z, Hue) }
#end

#macro Tile (Size, X, Y, Z, Hue)
  #local Half = 0.5 * Size;
  #local V1 = LorentzZ(X + Half,  Y,  Z + Half);
  #local V2 = LorentzZ(X - Half,  Y,  Z + Half);
  #local V4 = LorentzZ(X + Half,  Y,  Z - Half);
  #local V7 = LorentzZ(X - Half,  Y,  Z - Half);
  Tiloid(V7, V2, V4, V1, Hue)
#end

#macro ZTile (Size, X, Y, Z, Hue)
  #local Half = 0.5 * Size;
  #local V1 = LorentzZ(X + Half,  Y + Half, Z);
  #local V2 = LorentzZ(X - Half,  Y + Half, Z);
  #local V4 = LorentzZ(X + Half,  Y - Half, Z);
  #local V7 = LorentzZ(X - Half,  Y - Half, Z);
  Tiloid(V7, V2, V4, V1, Hue)
#end

#macro Cuboid (V1, V2, V3, V4, V5, V6, V7, V8)
  /* top side */
  triangle { V7, V4, V1 DopplerColour(X, Y, Z, HPaleBlue) }
  triangle { V7, V2, V1 DopplerColour(X, Y, Z, HPaleBlue) }
  /* bottom side */
  triangle { V8, V6, V3 DopplerColour(X, Y, Z, HPaleBlue) }
  triangle { V8, V5, V3 DopplerColour(X, Y, Z, HPaleBlue) }
  /* left side */
  triangle { V8, V5, V2 DopplerColour(X, Y, Z, HPaleBlue) }
  triangle { V8, V7, V2 DopplerColour(X, Y, Z, HPaleBlue) }
  /* right side */
  triangle { V6, V3, V1 DopplerColour(X, Y, Z, HPaleBlue) }
  triangle { V6, V1, V4 DopplerColour(X, Y, Z, HPaleBlue) }
  /* front side */
  triangle { V8, V6, V7 DopplerColour(X, Y, Z, HPaleBlue) }
  triangle { V7, V4, V6 DopplerColour(X, Y, Z, HPaleBlue) }
  /* back side */
  triangle { V5, V3, V2 DopplerColour(X, Y, Z, HViolet) }
  triangle { V2, V1, V3 DopplerColour(X, Y, Z, HViolet) }
#end

#macro Cube (Size, X, Y, Z)
  #local Half = 0.5 * Size;
  #local V1 = LorentzZ(X + Half,  Y + Half,  Z + Half);
  #local V2 = LorentzZ(X - Half,  Y + Half,  Z + Half);
  #local V3 = LorentzZ(X + Half,  Y - Half,  Z + Half);
  #local V4 = LorentzZ(X + Half,  Y + Half,  Z - Half);
  #local V5 = LorentzZ(X - Half,  Y - Half,  Z + Half);
  #local V6 = LorentzZ(X + Half,  Y - Half,  Z - Half);
  #local V7 = LorentzZ(X - Half,  Y + Half,  Z - Half);
  #local V8 = LorentzZ(X - Half,  Y - Half,  Z - Half);
  Cuboid(V1, V2, V3, V4, V5, V6, V7, V8)
#end

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

#macro Bisect (I, J)
    LorentzZ(0.5 * (I.x + J.x), 0.5 * (I.y + J.y), 0.5 * (I.z + J.z))
#end

#macro Station (Size, X, Y, Z, T, Hue1, Hue2)
    #local Angle = 0.5 * pi * T / T0;
    #local Cos = cos(Angle);
    #local Sin = sin(Angle);
    #local Half = 0.5 * Size;
    #local A = <X + Half * Sin, Y + Half * Cos, Z>;
    #local B = <X, Y, Z + Half>;
    #local C = <X + Half * Cos, Y - Half * Sin, Z>;
    #local D = <X, Y, Z - Half>;
    #local E = <X - Half * Cos, Y + Half * Sin, Z>;
    #local F = <X - Half * Sin, Y - Half * Cos, Z>;
    #local AC = Bisect(A, C);
    #local CF = Bisect(C, F);
    #local FE = Bisect(F, E);
    #local EA = Bisect(E, A);
    #local DA = Bisect(D, A);
    #local DC = Bisect(D, C);
    #local DF = Bisect(D, F);
    #local DE = Bisect(D, E);
    #local AB = Bisect(A, B);
    #local BC = Bisect(B, C);
    #local BE = Bisect(B, E);
    #local BF = Bisect(B, F);
    #local A = LorentzZ(A.x, A.y, A.z);
    #local B = LorentzZ(B.x, B.y, B.z);
    #local C = LorentzZ(C.x, C.y, C.z);
    #local D = LorentzZ(D.x, D.y, D.z);
    #local E = LorentzZ(E.x, E.y, E.z);
    #local F = LorentzZ(F.x, F.y, F.z);
    triangle { A, AB, AC DopplerColour(X, Y, Z, Hue2) }
    triangle { C, AC, BC DopplerColour(X, Y, Z, Hue2) }
    triangle { B, BC, AB DopplerColour(X, Y, Z, Hue2) }
    triangle { AC, AB, BC DopplerColour(X, Y, Z, Hue2) }
    triangle { A, AC, DA DopplerColour(X, Y, Z, Hue1) }
    triangle { C, DC, AC DopplerColour(X, Y, Z, Hue1) }
    triangle { D, DA, DC DopplerColour(X, Y, Z, Hue1) }
    triangle { AC, DC, DA DopplerColour(X, Y, Z, Hue1) }
    triangle { A, DA, EA DopplerColour(X, Y, Z, Hue1) }
    triangle { E, EA, DE DopplerColour(X, Y, Z, Hue1) }
    triangle { D, DE, DA DopplerColour(X, Y, Z, Hue1) }
    triangle { EA, DA, DE DopplerColour(X, Y, Z, Hue1) }
    triangle { A, EA, AB DopplerColour(X, Y, Z, Hue2) }
    triangle { E, BE, EA DopplerColour(X, Y, Z, Hue2) }
    triangle { B, AB, BE DopplerColour(X, Y, Z, Hue2) }
    triangle { EA, BE, AB DopplerColour(X, Y, Z, Hue2) }
    triangle { F, FE, DF DopplerColour(X, Y, Z, Hue1) }
    triangle { E, DE, FE DopplerColour(X, Y, Z, Hue1) }
    triangle { D, DF, DE DopplerColour(X, Y, Z, Hue1) }
    triangle { FE, DE, DF DopplerColour(X, Y, Z, Hue1) }
    triangle { F, DF, CF DopplerColour(X, Y, Z, Hue1) }
    triangle { C, CF, DC DopplerColour(X, Y, Z, Hue1) }
    triangle { D, DC, DF DopplerColour(X, Y, Z, Hue1) }
    triangle { CF, DF, DC DopplerColour(X, Y, Z, Hue1) }
    triangle { F, CF, BF DopplerColour(X, Y, Z, Hue2) }
    triangle { C, BC, CF DopplerColour(X, Y, Z, Hue2) }
    triangle { B, BF, BC DopplerColour(X, Y, Z, Hue2) }
    triangle { CF, BC, BF DopplerColour(X, Y, Z, Hue2) }
    triangle { F, BF, FE DopplerColour(X, Y, Z, Hue2) }
    triangle { E, FE, BE DopplerColour(X, Y, Z, Hue2) }
    triangle { B, BE, BF DopplerColour(X, Y, Z, Hue2) }
    triangle { FE, BF, BE DopplerColour(X, Y, Z, Hue2) }
    #if (VisualAids > 0.0)
        sphere { A, 0.05 * Size pigment { colour Red } }
        sphere { F, 0.05 * Size pigment { colour White } }
    #end
#end

#macro ShipClock (Size, X, Y, Z, T, Colour)
    #local Angle = 0.5 * pi * T / T0;
    #local Cos = cos(Angle);
    #local Sin = sin(Angle);
    #local Half = 0.5 * Size;
    #local A = <X + Half * Sin, Y + Half * Cos, Z>;
    #local F = <X - Half * Sin, Y - Half * Cos, Z>;
    sphere { A, 0.003 pigment { colour Colour } }
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
#macro WallOfTiles (Size, Z, Hue1, Hue2)
    #local Half = 0.5 * Size;
    #local Hue = Hue1;
    #local Yt = -2.0;
    #while (Yt < 2.0)
        #if (mod(Yt, 1) = 0.0)
        #if (Hue = Hue1)
            #local Hue = Hue2;
        #else
            #local Hue = Hue1;
        #end
        #end
        #local Xt = -2.0 + Half;
	#while (Xt < 2.0)
            ZTile(Size, Xt, Yt + Half, Z, Hue)
            #local Xt = Xt + Size;
        #end
        #local Yt = Yt + Size;
    #end
#end

// Tiles
#macro Tiles (Size, Y, Hue1, Hue2)
    #local Half = 0.5 * Size;
    #local Hue = Hue1;
    #local Zt = 0.0;
    #while (Zt < TotalZ + 5.0)
        #if (mod(Zt, 1) = 0.0)
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
    Tiles(0.125, -0.5, HRed, HViolet)
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
    Station(0.25, Xc, Yc, Zc, Time - Delay(Xc, Yc, Zc - dZ), HBlue, HOrange)
    #local Zc = Zc + 1;
#end

// Destination
Station(1.0, 0.0, 0.0, TotalZ + 0.6, Time - Delay(0.0, 0.0, TotalZ - dZ), HBlue, HOrange)
//Icosahedron(1.0, 0.0, 0.0, TotalZ + 1.5, Time - Delay(0.0, 0.0, TotalZ - dZ))
//IsoSphere (0.0, 0.0, TotalZ + 5.0)

//WallOfTiles(0.25, TotalZ + 6.0, HBlue, HYellow)
WallOfTiles(0.25, -1.0, HBlue, HYellow)

// Sun
#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
sphere { LorentzZ(X, Y, Z), 10.0 DopplerColour(X, Y, Z, HOrange) }

#if (VisualAids > 0.0)
    #if (-V > 0.1)
    #local XY = sqrt((V * GAMMA) * (V * GAMMA) - (GAMMA - 1.0) * (GAMMA - 1.0)) / (GAMMA - 1.0);
    // Doppler indicators
    #local RTXY = 0.5 * sqrt(2.0) * XY;
    sphere { <XY, 0.0, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <RTXY, RTXY, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <0.0, XY, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <RTXY, -RTXY, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <-XY, 0.0, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <-RTXY, RTXY, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <0.0, -XY, 1.0>, 0.01 pigment { colour Grey } }
    sphere { <-RTXY, -RTXY, 1.0>, 0.01 pigment { colour Grey } }
    #end
    // Position indicators
    sphere { LorentzZ(1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.0, 1.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-1.0, 0.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.0, -1.0, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-0.7, 0.7, dZ), 0.05 pigment { colour Magenta } }
    sphere { LorentzZ(-0.7, -0.7, dZ), 0.05 pigment { colour Magenta } }
    #if (LookForward > 0.0)
        // Ship clock face
        sphere { <-1.2, 0.6, 0.8>, 0.001 pigment { colour Grey } }
        #local Angle = 0.0;
        #local Hour = pi / 6.0;
        #while (Angle < 2.0 * pi)
            sphere { <-1.2 + 0.1 * sin(Angle), 0.6 + 0.1 * cos(Angle), 0.8>, 0.001 pigment { colour Grey } }
            #local Angle = Angle + Hour;
        #end
        // Ship clocks
        ShipClock(0.2, -1.2, 0.6, 0.8, Tau, Green)
        ShipClock(0.2, -1.2, 0.6, 0.8, Time, Red)
        #if (Reverse > 0.0)
            ShipClock(0.2, -1.2, 0.6, 0.8, Time - Delay(0.0, 0.0, TotalZ - dZ), Yellow)
        #else
            ShipClock(0.2, -1.2, 0.6, 0.8, Time - Delay(0.0, 0.0, dZ), Yellow)
        #end
    #end
#end


#debug concat("tau: ", str(Tau,3,3))
#debug concat(", TS: ", str(Time - Delay(1.0, 0.0, - dZ),3,3))
#debug concat(", TD: ", str(Time - Delay(1.0, 0.0, TotalZ - dZ),3,3))
#debug concat(", t: ", str(Time,3,3))
#if (Reverse < 0.0)
    #debug concat(", z: ", str(dZ,3,3))
    #debug concat(", TH: ", str(Time + Delay(0.0, 0.0, dZ),3,3))
#else
    #debug concat(", z: ", str(TotalZ - dZ,3,3))
    #debug concat(", TH: ", str(Time + Delay(0.0, 0.0, TotalZ - dZ),3,3))
#end
#debug concat(", T1: ", str(Time - Delay(1.0, 0.0, 0.1 * TotalZ - dZ),3,3))
#debug concat(", T2: ", str(Time - Delay(1.0, 0.0, 0.2 * TotalZ - dZ),3,3))
#debug concat(", T3: ", str(Time - Delay(1.0, 0.0, 0.3 * TotalZ - dZ),3,3))
#debug concat(", T4: ", str(Time - Delay(1.0, 0.0, 0.4 * TotalZ - dZ),3,3))
#debug concat(", T5: ", str(Time - Delay(1.0, 0.0, 0.5 * TotalZ - dZ),3,3))
#debug concat(", T6: ", str(Time - Delay(1.0, 0.0, 0.6 * TotalZ - dZ),3,3))
#debug concat(", T7: ", str(Time - Delay(1.0, 0.0, 0.7 * TotalZ - dZ),3,3))
#debug concat(", T8: ", str(Time - Delay(1.0, 0.0, 0.8 * TotalZ - dZ),3,3))
#debug concat(", T9: ", str(Time - Delay(1.0, 0.0, 0.9 * TotalZ - dZ),3,3))
//#debug concat(", v: ", str(V,3,3))
//#debug concat(", gamma: ", str(GAMMA,3,3))
#debug concat("\n")

