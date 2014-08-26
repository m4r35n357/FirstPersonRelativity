
#declare HRed = 0.0;
#declare HOrange = 30.0;
#declare HYellow = 60.0;
#declare HLime = 90.0;
#declare HGreen = 120.0;
#declare HTurquoise = 150.0;
#declare HCyan = 180.0;
#declare HPaleBlue = 210.0;
#declare HBlue = 240.0;
#declare HIndigo = 270.0;
#declare HViolet = 300.0;

#macro HSLTexture (X, Y, Z, Colour)
    texture { pigment { colour Doppler(X, Y, Z, Colour) } }
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

#macro Station (Size, X, Y, Z)
    #local Half = Size / 2.0;
    #local A = LorentzZ(X, Y + Size, Z);
    #local B = LorentzZ(X - Half, Y, Z + Half);
    #local C = LorentzZ(X + Half, Y, Z + Half);
    #local D = LorentzZ(X + Half, Y, Z - Half);
    #local E = LorentzZ(X - Half, Y, Z - Half);
    #local F = LorentzZ(X, Y - Size, Z);
    triangle { A, B, C HSLTexture(X, Y, Z, HRed) }
    triangle { A, C, D HSLTexture(X, Y, Z, HBlue) }
    triangle { A, D, E HSLTexture(X, Y, Z, HBlue) }
    triangle { A, E, B HSLTexture(X, Y, Z, HBlue) }
    triangle { F, E, D HSLTexture(X, Y, Z, HBlue) }
    triangle { F, D, C HSLTexture(X, Y, Z, HBlue) }
    triangle { F, C, B HSLTexture(X, Y, Z, HRed) }
    triangle { F, B, E HSLTexture(X, Y, Z, HBlue) }
#end

#macro Icosohedron (Size, X, Y, Z)
    #local dA = Size * 0.525731112119133606;
    #local dB = Size * 0.850650808352039932;
    #local V0 = LorentzZ(X - dA, Y, Z + dB);
    #local V1 = LorentzZ(X + dA, Y, Z + dB);
    #local V2 = LorentzZ(X - dA, Y, Z - dB);
    #local V3 = LorentzZ(X + dA, Y, Z - dB);
    #local V4 = LorentzZ(X, Y + dB, Z + dA);
    #local V5 = LorentzZ(X, Y + dB, Z - dA);
    #local V6 = LorentzZ(X, Y - dB, Z + dA);
    #local V7 = LorentzZ(X, Y - dB, Z - dA);
    #local V8 = LorentzZ(X + dB, Y + dA, Z);
    #local V9 = LorentzZ(X - dB, Y + dA, Z);
    #local V10 = LorentzZ(X + dB, Y - dA, Z);
    #local V11 = LorentzZ(X - dB, Y - dA, Z);
    triangle { V0, V4, V1 HSLTexture(X, Y, Z, HGreen) }
    triangle { V0, V9, V4 HSLTexture(X, Y, Z, HGreen) }
    triangle { V9, V5, V4 HSLTexture(X, Y, Z, HGreen) }
    triangle { V4, V5, V8 HSLTexture(X, Y, Z, HGreen) }
    triangle { V4, V8, V1 HSLTexture(X, Y, Z, HRed) }
    triangle { V8, V10, V1 HSLTexture(X, Y, Z, HGreen) }
    triangle { V8, V3, V10 HSLTexture(X, Y, Z, HGreen) }
    triangle { V5, V3, V8 HSLTexture(X, Y, Z, HViolet) }
    triangle { V5, V2, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V2, V7, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V10, V3 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V6, V10 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V11, V6 HSLTexture(X, Y, Z, HGreen) }
    triangle { V11, V0, V6 HSLTexture(X, Y, Z, HGreen) }
    triangle { V0, V1, V6 HSLTexture(X, Y, Z, HGreen) }
    triangle { V6, V1, V10 HSLTexture(X, Y, Z, HGreen) }
    triangle { V9, V0, V11 HSLTexture(X, Y, Z, HGreen) }
    triangle { V9, V11, V2 HSLTexture(X, Y, Z, HGreen) }
    triangle { V9, V2, V5 HSLTexture(X, Y, Z, HGreen) }
    triangle { V7, V2, V11 HSLTexture(X, Y, Z, HGreen) }
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HYellow) }
        #else
            sphere { LorentzZ(X, Y, Z), 0.005 HSLTexture(X, Y, Z, HYellow) }
        #end
        #local Z = Z + 1;
    #end
#end

