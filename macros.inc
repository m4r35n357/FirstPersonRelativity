#include "colors.inc"

#declare HRed = 0.0;
#declare HOrange = 30.0;
#declare HYellow = 60.0;
#declare HLime = 90.0;
#declare HGreen = 120.0;
#declare HTurquoise = 150.0;
#declare HCyan = 180.0;
#declare HPaleBlue = 210.0;
#declare HBlue = 240.0;

#macro HSLTexture (X, Y, Z, Colour)
texture { pigment { color Doppler(X, Y, Z, Colour) } }
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
                        #if ( NrZ = 0 ) HSLTexture(X, Y, Z, HRed) #end
                        #if ( NrZ = 3 ) HSLTexture(X, Y, Z, HYellow) #end
                        #if ( NrZ = 6 ) HSLTexture(X, Y, Z, HLime) #end
                        #if ( NrZ = 9 ) HSLTexture(X, Y, Z, HTurquoise) #end
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

#macro Station (Size, X, Y, Z)
union {
    #local Half = Size / 2.0;
    #local A = LorentzZ(X, Size + Y, Z);
    #local B = LorentzZ(-Half + X, Y, Half + Z);
    #local C = LorentzZ(Half + X, Y, Half + Z);
    #local D = LorentzZ(Half + X, Y, -Half + Z);
    #local E = LorentzZ(-Half + X, Y, -Half + Z);
    #local F = LorentzZ(X, -Size + Y, Z);
    triangle { A, B, C HSLTexture(X, Y, Z, HRed) }
    triangle { A, C, D HSLTexture(X, Y, Z, HYellow) }
    triangle { A, D, E HSLTexture(X, Y, Z, HGreen) }
    triangle { A, E, B HSLTexture(X, Y, Z, HBlue) }
    triangle { F, E, D HSLTexture(X, Y, Z, HGreen) }
    triangle { F, D, C HSLTexture(X, Y, Z, HBlue) }
    triangle { F, C, B HSLTexture(X, Y, Z, HRed) }
    triangle { F, B, E HSLTexture(X, Y, Z, HYellow) }
}
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { LorentzZ(X, Y, Z), 0.02 HSLTexture(X, Y, Z, HYellow) }
        #else
            sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HOrange) }
        #end
        #local Z = Z + 1;
    #end
#end

