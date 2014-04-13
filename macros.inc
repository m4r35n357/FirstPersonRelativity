#include "colors.inc"

#macro HSLTexture (X, Y, Z, Colour)
texture { pigment { color Doppler(X, Y, Z, Colour) } }
//texture { pigment { color rgb Doppler(X, Y, Z, Colour) } }
#end

#macro AsteroidGrid (Size, CX, CY, CZ)
//union {
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
                        #if ( NrZ = 0 ) HSLTexture(X, Y, Z, Red) #end
                        #if ( NrZ = 3 ) HSLTexture(X, Y, Z, Yellow) #end
                        #if ( NrZ = 6 ) HSLTexture(X, Y, Z, Green) #end
                        #if ( NrZ = 9 ) HSLTexture(X, Y, Z, Cyan) #end
                    }
                #end
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 3;
    #end
//}
#end

#macro Station (Size, CX, CY, CZ)
union {
    #local Half = Size / 2.0;
    #local A = LorentzZ(CX, Size + CY, CZ);
    #local B = LorentzZ(-Half + CX, CY, Half + CZ);
    #local C = LorentzZ(Half + CX, CY, Half + CZ);
    #local D = LorentzZ(Half + CX, CY, -Half + CZ);
    #local E = LorentzZ(-Half + CX, CY, -Half + CZ);
    #local F = LorentzZ(CX, -Size + CY, CZ);
    triangle { A, B, C HSLTexture(CX, CY, CZ, Red) }
    triangle { A, C, D HSLTexture(CX, CY, CZ, Yellow) }
    triangle { A, D, E HSLTexture(CX, CY, CZ, Green) }
    triangle { A, E, B HSLTexture(CX, CY, CZ, Blue) }
    triangle { F, E, D HSLTexture(CX, CY, CZ, Green) }
    triangle { F, D, C HSLTexture(CX, CY, CZ, Blue) }
    triangle { F, C, B HSLTexture(CX, CY, CZ, Red) }
    triangle { F, B, E HSLTexture(CX, CY, CZ, Yellow) }
}
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { LorentzZ(X, Y, Z), 0.02 HSLTexture(X, Y, Z, Yellow) }
        #else
            sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, Yellow) }
        #end
        #local Z = Z + 1;
    #end
#end

