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

#macro Lorentz (W)  // Special Relativity happens here . . .
    <W.x, W.y, GAMMA * (W.z - dZ - V * Delay(W.x, W.y, W.z - dZ))>
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

#macro HSLTexture (X, Y, Z, Colour)
    texture { pigment { colour Doppler(X, Y, Z, Colour) } }
#end

#macro IsoSphere (X, Y, Z)
  #local V0 = LorentzZ(0.000000 + X, 0.000000 + Y, -1.000000 + Z);
  #local V1 = LorentzZ(0.723607 + X, -0.525725 + Y, -0.447220 + Z);
  #local V2 = LorentzZ(-0.276388 + X, -0.850649 + Y, -0.447220 + Z);
  #local V3 = LorentzZ(-0.894426 + X, 0.000000 + Y, -0.447216 + Z);
  #local V4 = LorentzZ(-0.276388 + X, 0.850649 + Y, -0.447220 + Z);
  #local V5 = LorentzZ(0.723607 + X, 0.525725 + Y, -0.447220 + Z);
  #local V6 = LorentzZ(0.276388 + X, -0.850649 + Y, 0.447220 + Z);
  #local V7 = LorentzZ(-0.723607 + X, -0.525725 + Y, 0.447220 + Z);
  #local V8 = LorentzZ(-0.723607 + X, 0.525725 + Y, 0.447220 + Z);
  #local V9 = LorentzZ(0.276388 + X, 0.850649 + Y, 0.447220 + Z);
  #local V10 = LorentzZ(0.894426 + X, 0.000000 + Y, 0.447216 + Z);
  #local V11 = LorentzZ(0.000000 + X, 0.000000 + Y, 1.000000 + Z);
  #local V12 = LorentzZ(-0.162456 + X, -0.499995 + Y, -0.850654 + Z);
  #local V13 = LorentzZ(0.425323 + X, -0.309011 + Y, -0.850654 + Z);
  #local V14 = LorentzZ(0.262869 + X, -0.809012 + Y, -0.525738 + Z);
  #local V15 = LorentzZ(0.850648 + X, 0.000000 + Y, -0.525736 + Z);
  #local V16 = LorentzZ(0.425323 + X, 0.309011 + Y, -0.850654 + Z);
  #local V17 = LorentzZ(-0.525730 + X, 0.000000 + Y, -0.850652 + Z);
  #local V18 = LorentzZ(-0.688189 + X, -0.499997 + Y, -0.525736 + Z);
  #local V19 = LorentzZ(-0.162456 + X, 0.499995 + Y, -0.850654 + Z);
  #local V20 = LorentzZ(-0.688189 + X, 0.499997 + Y, -0.525736 + Z);
  #local V21 = LorentzZ(0.262869 + X, 0.809012 + Y, -0.525738 + Z);
  #local V22 = LorentzZ(0.951058 + X, -0.309013 + Y, 0.000000 + Z);
  #local V23 = LorentzZ(0.951058 + X, 0.309013 + Y, 0.000000 + Z);
  #local V24 = LorentzZ(0.000000 + X, -1.000000 + Y, 0.000000 + Z);
  #local V25 = LorentzZ(0.587786 + X, -0.809017 + Y, 0.000000 + Z);
  #local V26 = LorentzZ(-0.951058 + X, -0.309013 + Y, 0.000000 + Z);
  #local V27 = LorentzZ(-0.587786 + X, -0.809017 + Y, 0.000000 + Z);
  #local V28 = LorentzZ(-0.587786 + X, 0.809017 + Y, 0.000000 + Z);
  #local V29 = LorentzZ(-0.951058 + X, 0.309013 + Y, 0.000000 + Z);
  #local V30 = LorentzZ(0.587786 + X, 0.809017 + Y, 0.000000 + Z);
  #local V31 = LorentzZ(0.000000 + X, 1.000000 + Y, 0.000000 + Z);
  #local V32 = LorentzZ(0.688189 + X, -0.499997 + Y, 0.525736 + Z);
  #local V33 = LorentzZ(-0.262869 + X, -0.809012 + Y, 0.525738 + Z);
  #local V34 = LorentzZ(-0.850648 + X, 0.000000 + Y, 0.525736 + Z);
  #local V35 = LorentzZ(-0.262869 + X, 0.809012 + Y, 0.525738 + Z);
  #local V36 = LorentzZ(0.688189 + X, 0.499997 + Y, 0.525736 + Z);
  #local V37 = LorentzZ(0.162456 + X, -0.499995 + Y, 0.850654 + Z);
  #local V38 = LorentzZ(0.525730 + X, 0.000000 + Y, 0.850652 + Z);
  #local V39 = LorentzZ(-0.425323 + X, -0.309011 + Y, 0.850654 + Z);
  #local V40 = LorentzZ(-0.425323 + X, 0.309011 + Y, 0.850654 + Z);
  #local V41 = LorentzZ(0.162456 + X, 0.499995 + Y, 0.850654  + Z);
  #local V42 = LorentzZ(0.000000 + X, 0.000000 + Y, -1.000000 + Z);

//  triangle { V0, V13, V13 HSLTexture(X, Y, Z, HViolet) }
  triangle { V1, V13, V16 HSLTexture(X, Y, Z, HViolet) }
  triangle { V0, V12, V18 HSLTexture(X, Y, Z, HViolet) }
  triangle { V0, V17, V20 HSLTexture(X, Y, Z, HViolet) }
  triangle { V0, V19, V17 HSLTexture(X, Y, Z, HViolet) }
  triangle { V1, V15, V23 HSLTexture(X, Y, Z, HViolet) }
  triangle { V2, V14, V25 HSLTexture(X, Y, Z, HViolet) }
  triangle { V3, V18, V27 HSLTexture(X, Y, Z, HViolet) }
  triangle { V4, V20, V29 HSLTexture(X, Y, Z, HViolet) }
  triangle { V5, V21, V31 HSLTexture(X, Y, Z, HViolet) }
  triangle { V1, V22, V26 HSLTexture(X, Y, Z, HViolet) }
  triangle { V2, V24, V28 HSLTexture(X, Y, Z, HViolet) }
  triangle { V3, V26, V30 HSLTexture(X, Y, Z, HViolet) }
  triangle { V4, V28, V32 HSLTexture(X, Y, Z, HViolet) }
  triangle { V5, V30, V24 HSLTexture(X, Y, Z, HViolet) }
  triangle { V6, V32, V38 HSLTexture(X, Y, Z, HViolet) }
  triangle { V7, V33, V40 HSLTexture(X, Y, Z, HViolet) }
  triangle { V8, V34, V41 HSLTexture(X, Y, Z, HViolet) }
  triangle { V9, V35, V42 HSLTexture(X, Y, Z, HViolet) }
  triangle { V10, V36, V39 HSLTexture(X, Y, Z, HViolet) }
  triangle { V12, V14, V3 HSLTexture(X, Y, Z, HViolet) }
  triangle { V12, V13, V15 HSLTexture(X, Y, Z, HViolet) }
  triangle { V13, V1, V15 HSLTexture(X, Y, Z, HViolet) }
  triangle { V15, V16, V6 HSLTexture(X, Y, Z, HViolet) }
  triangle { V15, V13, V17 HSLTexture(X, Y, Z, HViolet) }
  triangle { V13, V0, V17 HSLTexture(X, Y, Z, HViolet) }
  triangle { V17, V18, V4 HSLTexture(X, Y, Z, HViolet) }
  triangle { V17, V12, V19 HSLTexture(X, Y, Z, HViolet) }
  triangle { V12, V2, V19 HSLTexture(X, Y, Z, HViolet) }
  triangle { V19, V20, V5 HSLTexture(X, Y, Z, HViolet) }
  triangle { V19, V17, V21 HSLTexture(X, Y, Z, HViolet) }
  triangle { V17, V3, V21 HSLTexture(X, Y, Z, HViolet) }
  triangle { V16, V21, V6 HSLTexture(X, Y, Z, HViolet) }
  triangle { V16, V19, V22 HSLTexture(X, Y, Z, HViolet) }
  triangle { V19, V4, V22 HSLTexture(X, Y, Z, HViolet) }
  triangle { V22, V23, V11 HSLTexture(X, Y, Z, HViolet) }
  triangle { V22, V15, V24 HSLTexture(X, Y, Z, HViolet) }
  triangle { V15, V5, V24 HSLTexture(X, Y, Z, HViolet) }
  triangle { V24, V25, V7 HSLTexture(X, Y, Z, HViolet) }
  triangle { V24, V14, V26 HSLTexture(X, Y, Z, HViolet) }
  triangle { V14, V1, V26 HSLTexture(X, Y, Z, HViolet) }
  triangle { V26, V27, V8 HSLTexture(X, Y, Z, HViolet) }
  triangle { V26, V18, V28 HSLTexture(X, Y, Z, HViolet) }
  triangle { V18, V2, V28 HSLTexture(X, Y, Z, HViolet) }
  triangle { V28, V29, V9 HSLTexture(X, Y, Z, HViolet) }
  triangle { V28, V20, V30 HSLTexture(X, Y, Z, HViolet) }
  triangle { V20, V3, V30 HSLTexture(X, Y, Z, HViolet) }
  triangle { V30, V31, V10 HSLTexture(X, Y, Z, HViolet) }
  triangle { V30, V21, V32 HSLTexture(X, Y, Z, HViolet) }
  triangle { V21, V4, V32 HSLTexture(X, Y, Z, HViolet) }
  triangle { V25, V32, V7 HSLTexture(X, Y, Z, HViolet) }
  triangle { V25, V22, V33 HSLTexture(X, Y, Z, HViolet) }
  triangle { V22, V10, V33 HSLTexture(X, Y, Z, HViolet) }
  triangle { V27, V33, V8 HSLTexture(X, Y, Z, HViolet) }
  triangle { V27, V24, V34 HSLTexture(X, Y, Z, HViolet) }
  triangle { V24, V6, V34 HSLTexture(X, Y, Z, HViolet) }
  triangle { V29, V34, V9 HSLTexture(X, Y, Z, HViolet) }
  triangle { V29, V26, V35 HSLTexture(X, Y, Z, HViolet) }
  triangle { V26, V7, V35 HSLTexture(X, Y, Z, HViolet) }
  triangle { V31, V35, V10 HSLTexture(X, Y, Z, HViolet) }
  triangle { V31, V28, V36 HSLTexture(X, Y, Z, HViolet) }
  triangle { V28, V8, V36 HSLTexture(X, Y, Z, HViolet) }
  triangle { V23, V36, V11 HSLTexture(X, Y, Z, HViolet) }
  triangle { V23, V30, V37 HSLTexture(X, Y, Z, HViolet) }
  triangle { V30, V9, V37 HSLTexture(X, Y, Z, HViolet) }
  triangle { V37, V38, V12 HSLTexture(X, Y, Z, HViolet) }
  triangle { V37, V32, V39 HSLTexture(X, Y, Z, HViolet) }
  triangle { V32, V10, V39 HSLTexture(X, Y, Z, HViolet) }
  triangle { V39, V37, V12 HSLTexture(X, Y, Z, HViolet) }
  triangle { V39, V33, V38 HSLTexture(X, Y, Z, HViolet) }
  triangle { V33, V6, V38 HSLTexture(X, Y, Z, HViolet) }
  triangle { V40, V39, V12 HSLTexture(X, Y, Z, HViolet) }
//  triangle { V40, V34, V40 HSLTexture(X, Y, Z, HViolet) }
  triangle { V34, V7, V40 HSLTexture(X, Y, Z, HViolet) }
  triangle { V41, V40, V12 HSLTexture(X, Y, Z, HViolet) }
//  triangle { V41, V35, V41 HSLTexture(X, Y, Z, HViolet) }
  triangle { V35, V8, V41 HSLTexture(X, Y, Z, HViolet) }
  triangle { V38, V41, V12 HSLTexture(X, Y, Z, HViolet) }
  triangle { V38, V36, V42 HSLTexture(X, Y, Z, HViolet) }
  triangle { V36, V9, V42 HSLTexture(X, Y, Z, HViolet) }
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HGreen) }
        #else
            sphere { LorentzZ(X, Y, Z), 0.005 HSLTexture(X, Y, Z, HGreen) }
        #end
        #local Z = Z + 1;
    #end
#end

#macro Tiloid (vA, vB, vC, vD, Hue)
  triangle { vA, vB, vD HSLTexture(X, Y, Z, Hue) }
  triangle { vA, vC, vD HSLTexture(X, Y, Z, Hue) }
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
  triangle { V7, V4, V1 HSLTexture(X, Y, Z, HPaleBlue) }
  triangle { V7, V2, V1 HSLTexture(X, Y, Z, HPaleBlue) }
  /* bottom side */
  triangle { V8, V6, V3 HSLTexture(X, Y, Z, HPaleBlue) }
  triangle { V8, V5, V3 HSLTexture(X, Y, Z, HPaleBlue) }
  /* left side */
  triangle { V8, V5, V2 HSLTexture(X, Y, Z, HPaleBlue) }
  triangle { V8, V7, V2 HSLTexture(X, Y, Z, HPaleBlue) }
  /* right side */
  triangle { V6, V3, V1 HSLTexture(X, Y, Z, HPaleBlue) }
  triangle { V6, V1, V4 HSLTexture(X, Y, Z, HPaleBlue) }
  /* front side */
  triangle { V8, V6, V7 HSLTexture(X, Y, Z, HPaleBlue) }
  triangle { V7, V4, V6 HSLTexture(X, Y, Z, HPaleBlue) }
  /* back side */
  triangle { V5, V3, V2 HSLTexture(X, Y, Z, HViolet) }
  triangle { V2, V1, V3 HSLTexture(X, Y, Z, HViolet) }
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
    Lorentz(<0.5 * (I.x + J.x), 0.5 * (I.y + J.y), 0.5 * (I.z + J.z)>)
#end

#macro Octohedron (Size, X, Y, Z, T)
    #local Angle = 0.5 * pi * T / T0;
    #local Cos = cos(Angle);
    #local Sin = sin(Angle);
    #local Half = 0.5 * Size;
    #local A = LorentzZ(X + Half * Sin, Y + Half * Cos, Z);
    #local B = LorentzZ(X, Y, Z + Half);
    #local C = LorentzZ(X + Half * Cos, Y - Half * Sin, Z);
    #local D = LorentzZ(X, Y, Z - Half);
    #local E = LorentzZ(X - Half * Cos, Y + Half * Sin, Z);
    #local F = LorentzZ(X - Half * Sin, Y - Half * Cos, Z);
    triangle { A, B, C HSLTexture(X, Y, Z, HOrange) }
    triangle { A, C, D HSLTexture(X, Y, Z, HBlue) }
    triangle { A, D, E HSLTexture(X, Y, Z, HBlue) }
    triangle { A, E, B HSLTexture(X, Y, Z, HOrange) }
    triangle { F, E, D HSLTexture(X, Y, Z, HBlue) }
    triangle { F, D, C HSLTexture(X, Y, Z, HBlue) }
    triangle { F, C, B HSLTexture(X, Y, Z, HOrange) }
    triangle { F, B, E HSLTexture(X, Y, Z, HOrange) }
    #if (VisualAids > 0.0)
        sphere { A, 0.05 * Size pigment { colour Red } }
        sphere { F, 0.05 * Size pigment { colour White } }
    #end
#end

#macro Station (Size, X, Y, Z, T)
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
    #local A = Lorentz(A);
    #local B = Lorentz(B);
    #local C = Lorentz(C);
    #local D = Lorentz(D);
    #local E = Lorentz(E);
    #local F = Lorentz(F);
    triangle { A, AB, AC HSLTexture(X, Y, Z, HOrange) }
    triangle { C, AC, BC HSLTexture(X, Y, Z, HOrange) }
    triangle { B, BC, AB HSLTexture(X, Y, Z, HOrange) }
    triangle { AC, AB, BC HSLTexture(X, Y, Z, HOrange) }
//    triangle { A, C, D HSLTexture(X, Y, Z, HBlue) } //
    triangle { A, AC, DA HSLTexture(X, Y, Z, HBlue) }
    triangle { C, DC, AC HSLTexture(X, Y, Z, HBlue) }
    triangle { D, DA, DC HSLTexture(X, Y, Z, HBlue) }
    triangle { AC, DC, DA HSLTexture(X, Y, Z, HBlue) }
//    triangle { A, D, E HSLTexture(X, Y, Z, HBlue) } //
    triangle { A, DA, EA HSLTexture(X, Y, Z, HBlue) }
    triangle { E, EA, DE HSLTexture(X, Y, Z, HBlue) }
    triangle { D, DE, DA HSLTexture(X, Y, Z, HBlue) }
    triangle { EA, DA, DE HSLTexture(X, Y, Z, HBlue) }
    triangle { A, EA, AB HSLTexture(X, Y, Z, HOrange) }
    triangle { E, BE, EA HSLTexture(X, Y, Z, HOrange) }
    triangle { B, AB, BE HSLTexture(X, Y, Z, HOrange) }
    triangle { EA, BE, AB HSLTexture(X, Y, Z, HOrange) }
//    triangle { F, E, D HSLTexture(X, Y, Z, HBlue) } //
    triangle { F, FE, DF HSLTexture(X, Y, Z, HBlue) }
    triangle { E, DE, FE HSLTexture(X, Y, Z, HBlue) }
    triangle { D, DF, DE HSLTexture(X, Y, Z, HBlue) }
    triangle { FE, DE, DF HSLTexture(X, Y, Z, HBlue) }
//    triangle { F, D, C HSLTexture(X, Y, Z, HBlue) } //
    triangle { F, DF, CF HSLTexture(X, Y, Z, HBlue) }
    triangle { C, CF, DC HSLTexture(X, Y, Z, HBlue) }
    triangle { D, DC, DF HSLTexture(X, Y, Z, HBlue) }
    triangle { CF, DF, DC HSLTexture(X, Y, Z, HBlue) }
    triangle { F, CF, BF HSLTexture(X, Y, Z, HOrange) }
    triangle { C, BC, CF HSLTexture(X, Y, Z, HOrange) }
    triangle { B, BF, BC HSLTexture(X, Y, Z, HOrange) }
    triangle { CF, BC, BF HSLTexture(X, Y, Z, HOrange) }
    triangle { F, BF, FE HSLTexture(X, Y, Z, HOrange) }
    triangle { E, FE, BE HSLTexture(X, Y, Z, HOrange) }
    triangle { B, BE, BF HSLTexture(X, Y, Z, HOrange) }
    triangle { FE, BF, BE HSLTexture(X, Y, Z, HOrange) }
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
    sphere { A, 0.005 pigment { colour Colour } }
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
    #local Yt = -1.0;
    #while (Yt < 1.0)
        #if (mod(Yt, 1) = 0.0)
        #if (Hue = Hue1)
            #local Hue = Hue2;
        #else
            #local Hue = Hue1;
        #end
        #end
        #local Xt = - 1.0 + Half;
	#while (Xt < 1.0)
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
    Station(0.25, Xc, Yc, Zc, Time - Delay(Xc, Yc, Zc - dZ))
    #local Zc = Zc + 1;
#end

// Destination
Station(1.0, 0.0, 0.0, TotalZ + 0.6, Time - Delay(0.0, 0.0, TotalZ - dZ))
//Icosahedron(1.0, 0.0, 0.0, TotalZ + 1.5, Time - Delay(0.0, 0.0, TotalZ - dZ))
//IsoSphere (0.0, 0.0, TotalZ + 5.0)

//WallOfTiles(0.25, TotalZ + 6.0, HBlue, HYellow)
WallOfTiles(0.25, -1.0, HBlue, HYellow)

// Sun
#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
sphere { LorentzZ(X, Y, Z), 10.0 HSLTexture(X, Y, Z, HOrange) }

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
    sphere { <-1.5, 0.8, 1.0>, 0.002 pigment { colour Grey } }
    #local Angle = 0.0;
    #local Hour = pi / 6.0;
    #while (Angle < 2.0 * pi)
        sphere { <-1.5 + 0.1 * sin(Angle), 0.8 + 0.1 * cos(Angle), 1.0>, 0.002 pigment { colour Grey } }
        #local Angle = Angle + Hour;
    #end
    // Ship clocks
    ShipClock(0.2, -1.5, 0.8, 1.0, Tau, Green)
    ShipClock(0.2, -1.5, 0.8, 1.0, Time, Red)
    ShipClock(0.2, -1.5, 0.8, 1.0, Time - Delay(0.0, 0.0, TotalZ - dZ), Yellow)
#end
//    ShipClock(0.2, -1.5, 0.8, 1.0, Time - Delay(0.0, 0.0, - dZ), Blue)
/*
#if (Reverse < 0.0)
    ShipClock(0.2, -1.5, 0.8, 1.0, Tau - Delay(0.0, 0.0, dZ), Blue)
#else
    ShipClock(0.2, -1.5, 0.8, 1.0, Tau - Delay(0.0, 0.0, TotalZ - dZ), Blue)
#end
    // Home clock face
    sphere { <1.5, 0.8, 1.0>, 0.002 pigment { colour Grey } }
    #local Angle = 0.0;
    #local Hour = pi / 6.0;
    #while (Angle < 2.0 * pi)
        sphere { <1.5 + 0.1 * sin(Angle), 0.8 + 0.1 * cos(Angle), 1.0>, 0.002 pigment { colour Grey } }
        #local Angle = Angle + Hour;
    #end
    // Ship clocks
    ShipClock(0.2, 1.5, 0.8, 1.0, Time, Red)
    ShipClock(0.2, 1.5, 0.8, 1.0, Tau + Delay(0.0, 0.0, TotalZ - dZ), Blue)
//    ShipClock(0.2, 1.5, 0.8, 1.0, Time + Delay(0.0, 0.0, dZ), Blue)
*/
#end

/*
#macro AsteroidGrid (Size, CX, CY, CZ)
    #local Offset = (Size - 1.0) / 2.0;
    #local NrZ = 0;
    #local EndNrZ = Size;
    #while (NrZ < EndNrZ) 
        #local NrY = 0;
        #local EndNrY = Size;
        #while (NrY < EndNrY) 
            #local NrX = 0;
            #local EndNrX = Size;
            #while (NrX < EndNrX) 
                #local X = NrX - Offset + CX;
                #local Y = NrY - Offset + CY;
                #local Z = NrZ - Offset + CZ;
                #if ( mod(NrX, 3) = 0 | mod(NrY, 3) = 0 )
                    sphere { LorentzZ(X, Y, Z), 0.05
                        #if ( NrZ = 0 ) HSLTexture(X, Y, Z, HRed) #end
                        #if ( NrZ = 3 ) HSLTexture(X, Y, Z, HYellow) #end
                        #if ( NrZ = 6 ) HSLTexture(X, Y, Z, HGreen) #end
                        #if ( NrZ = 9 ) HSLTexture(X, Y, Z, HBlue) #end
                    }
                #end
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 3;
    #end
#end

#macro Icosahedron (Size, X, Y, Z, T)
    #local Angle = - 0.5 * pi * T / T0;
    #local Cos = cos(Angle);
    #local Sin = sin(Angle);
    #local dA = Size * 0.525731112119133606;
    #local dB = Size * 0.850650808352039932;
    #local V0 = LorentzZ(X - dA * Cos, Y - dA * Sin, Z + dB);
    #local V1 = LorentzZ(X + dA * Cos, Y + dA * Sin, Z + dB);
    #local V2 = LorentzZ(X - dA * Cos, Y - dA * Sin, Z - dB);
    #local V3 = LorentzZ(X + dA * Cos, Y + dA * Sin, Z - dB);
    #local V4 = LorentzZ(X - dB * Sin, Y + dB * Cos, Z + dA);
    #local V5 = LorentzZ(X - dB * Sin, Y + dB * Cos, Z - dA);
    #local V6 = LorentzZ(X + dB * Sin, Y - dB * Cos, Z + dA);
    #local V7 = LorentzZ(X + dB * Sin, Y - dB * Cos, Z - dA);
    #local V8 = LorentzZ(X + dB * Cos - dA * Sin, Y + dA * Cos + dB * Sin, Z);
    #local V9 = LorentzZ(X - dB * Cos - dA * Sin, Y + dA * Cos - dB * Sin, Z);
    #local V10 = LorentzZ(X + dB * Cos + dA * Sin, Y - dA * Cos + dB * Sin, Z);
    #local V11 = LorentzZ(X - dB * Cos + dA * Sin, Y - dA * Cos - dB * Sin, Z);
    triangle { V0, V4, V1 HSLTexture(X, Y, Z, HRed) }
    triangle { V0, V9, V4 HSLTexture(X, Y, Z, HRed) }
    triangle { V9, V5, V4 HSLTexture(X, Y, Z, HGreen) }
    triangle { V4, V5, V8 HSLTexture(X, Y, Z, HGreen) }
    triangle { V4, V8, V1 HSLTexture(X, Y, Z, HRed) }
    triangle { V8, V10, V1 HSLTexture(X, Y, Z, HRed) }
    triangle { V8, V3, V10 HSLTexture(X, Y, Z, HGreen) }
    triangle { V5, V3, V8 HSLTexture(X, Y, Z, HGreen) }
    triangle { V5, V2, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V2, V7, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V10, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V6, V10 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V11, V6 HSLTexture(X, Y, Z, HGreen) }
    triangle { V11, V0, V6 HSLTexture(X, Y, Z, HRed) }
    triangle { V0, V1, V6 HSLTexture(X, Y, Z, HRed) }
    triangle { V6, V1, V10 HSLTexture(X, Y, Z, HRed) }
    triangle { V9, V0, V11 HSLTexture(X, Y, Z, HRed) }
    triangle { V9, V11, V2 HSLTexture(X, Y, Z, HGreen) }
    triangle { V9, V2, V5 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V2, V11 HSLTexture(X, Y, Z, HGreen) }
    #if (VisualAids > 0.0)
        sphere { V5, 0.05 * Size pigment { colour Red } }
        sphere { V7, 0.05 * Size pigment { colour White } }
    #end
#end

// Grids
//AsteroidGrid(10, 0.0, 0.0, 0.5 * TotalZ)

// Rings
#local Size = 0.1;
#local Zr = 0.0;
#while (Zr < TotalZ + 5.0)
    Icosahedron(Size, 1.0, -0.5, Zr)
    Icosahedron(Size, -0.5, 1.0, Zr)
    Icosahedron(Size, 1.0, 0.5, Zr)
    Icosahedron(Size, -0.5, -1.0, Zr)
    Icosahedron(Size, -1.0, 0.5, Zr)
    Icosahedron(Size, 0.5, -1.0, Zr)
    Icosahedron(Size, -1.0, -0.5, Zr)
    Icosahedron(Size, 0.5, 1.0, Zr)
    #local Zr = Zr + 10.0;
#end
*/

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

