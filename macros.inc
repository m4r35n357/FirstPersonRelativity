#include "colors.inc"

#macro WhiteTexture ()
texture { pigment { color rgb < 1.0, 1.0, 1.0 > } }
#end

#macro GreyTexture ()
texture { pigment { color rgb < 0.5, 0.5, 0.5 > } }
#end

#macro RedTexture ()
texture { pigment { color rgb < 1.0, 0.0, 0.0 > } }
#end

#macro GreenTexture ()
texture { pigment { color rgb < 0.0, 1.0, 0.0 > } }
#end

#macro DarkGreenTexture ()
texture { pigment { color rgb < 0.0, 0.5, 0.0 > } }
#end

#macro BlueTexture ()
texture { pigment { color rgb < 0.0, 0.0, 1.0 > } }
#end

#macro YellowTexture ()
texture { pigment { color rgb < 0.7, 0.7, 0.0 > } }
#end

#macro OrangeTexture ()
texture { pigment { color rgb < 0.8, 0.2, 0.0 > } }
#end

#macro CyanTexture ()
texture { pigment { color rgb < 0.0, 0.7, 0.7 > } }
#end

#macro MagentaTexture ()
texture { pigment { color rgb < 0.7, 0.0, 0.7 > } }
#end

#macro AsteroidGrid (Size, CX, CY, CZ)
union {
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
                    sphere { < X, Y, LTZ (X, Y, Z) >, 0.05
                        #if ( NrZ = 0 ) RedTexture() #end
                        #if ( NrZ = 3 ) YellowTexture() #end
                        #if ( NrZ = 6 ) GreenTexture() #end
                        #if ( NrZ = 9 ) CyanTexture() #end
                    }
                #end
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 3;
    #end
}
#end

#macro Station (Size, CX, CY, CZ)
union {
    #local Half = Size / 2.0;
    #local A = <CX, Size + CY, LTZ(CX, Size + CY, CZ) >;
    #local B = <-Half + CX, CY, LTZ(-Half + CX, CY, Half + CZ) >;
    #local C = <Half + CX, CY, LTZ(Half + CX, CY, Half + CZ) >;
    #local D = <Half + CX, CY, LTZ(Half + CX, CY, -Half + CZ) >;
    #local E = <-Half + CX, CY, LTZ(-Half + CX, CY, -Half + CZ) >;
    #local F = <CX, -Size + CY, LTZ(CX, -Size + CY, CZ) >;
    triangle { A, B, C RedTexture() }
    triangle { A, C, D WhiteTexture() }
    triangle { A, D, E DarkGreenTexture() }
    triangle { A, E, B BlueTexture() }
    triangle { F, E, D DarkGreenTexture() }
    triangle { F, D, C BlueTexture() }
    triangle { F, C, B RedTexture() }
    triangle { F, B, E WhiteTexture() }
}
#end

#macro Milestones (X, Y, Za, Zz)
    #local Z = Za;
    #while (Z <= Zz) 
        #if (mod(Z, 5) = 0)
            sphere { < X, Y, LTZ (X, Y, Z) >, 0.02 WhiteTexture() }
        #else
            sphere { < X, Y, LTZ (X, Y, Z) >, 0.01 GreyTexture() }
        #end
        #local Z = Z + 1;
    #end
#end

