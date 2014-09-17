
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

/*
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

