
#declare HRed = 0.0;
#declare HOrange = 30.0;
#declare HYellow = 60.0;
#declare HLime = 90.0;
#declare HGreen = 120.0;
#declare HTurquoise = 150.0;
#declare HCyan = 180.0;
#declare HPaleBlue = 210.0;
#declare HBlue = 240.0;
#declare HViolet = 260.0;

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
        CHSL2RGB(<260.0 - (260.0 - Hue) / DF, 1.0, 1.0 - 0.5 / DF>)
    #else  // red shift, darken
        CHSL2RGB(<Hue * DF, 1.0, 0.5 * DF>)
    #end
#end

#macro HSLTexture (X, Y, Z, Colour)
    texture { pigment { colour Doppler(X, Y, Z, Colour) } }
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

#macro Station (Size, X, Y, Z, T)
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

#macro Icosohedron (Size, X, Y, Z, T)
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

