#version 3.7;
#include "colors.inc"

#if (false)
    #declare V = 0.0;
    #declare Distance = 20.0 * (0.5 - clock);
    #declare Time = Distance / V;
    #declare GAMMA = 1.0 / sqrt(1.0 - V*V);
    #declare Tau = Time / GAMMA;
#else
    #declare A = 0.1;
    #declare TotalD = 20.0;
    #declare StartD = TotalD / 2.0;
    #declare TotalTau = 2.0 * acosh(A * StartD + 1.0) / A;
    #declare HalfTau = TotalTau / 2.0;
    #declare HalfD = TotalD / 2.0;
    #declare HalfT = sinh(A * HalfTau) / A;
    #declare Tau = clock * TotalTau;
    #if (Tau <= HalfTau)
        #declare Distance = StartD - (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = tanh(A * Tau);
    #else
        #declare Aut = TotalTau - Tau;
        #declare Distance = - HalfD + (cosh(A * Aut) - 1.0) / A;
        #declare Time = 2.0 * HalfT - sinh(A * Aut) / A;
        #declare V = tanh(A * Aut);
    #end
    #declare GAMMA = 1.0 / sqrt(1.0 - V*V);
#end

#debug concat(">>> V: ", str(V,3,2))
#debug concat(", GAMMA: ", str(GAMMA,3,3))
#debug concat(", Distance: ", str(Distance,3,1))
#debug concat(", Time: ", str(Time,3,1))
#debug concat(", Proper Time: ", str(Tau,3,1), " <<<\n")

#declare LTZ = function (X, Y, Z) {
    GAMMA * (Z + V * sqrt(X*X + Y*Y + Z*Z))
}

global_settings { assumed_gamma 1.8 }

light_source { <1, 1, 0> color White }
light_source { <-1, -1, 0> color White }

camera {
//  fisheye
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 120.0
  look_at < 0.0, 0.0, 100 >
}

#macro RedTexture ()
texture {
    pigment {
        color rgb < 1.0, 0.0, 0.0 >
    }
}
#end

#macro GreenTexture ()
texture {
    pigment {
        color rgb < 0.0, 1.0, 0.0 >
    }
}
#end

#macro BlueTexture ()
texture {
    pigment {
        color rgb < 0.0, 0.0, 1.0 >
    }
}
#end

#macro YellowTexture ()
texture {
    pigment {
        color rgb < 0.7, 0.7, 0.0 >
    }
}
#end

#macro CyanTexture ()
texture {
    pigment {
        color rgb < 0.0, 0.7, 0.7 >
    }
}
#end

#macro MagentaTexture ()
texture {
    pigment {
        color rgb < 0.7, 0.0, 0.7 >
    }
}
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
                        #if ( NrZ = 9 ) BlueTexture() #end
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
    triangle {
        A, B, C
        RedTexture ()
    }
    triangle {
        A, C, D
        YellowTexture ()
    }
    triangle {
        A, D, E
        GreenTexture ()
    }
    triangle {
        A, E, B
        BlueTexture ()
    }
    triangle {
        F, E, D
        GreenTexture ()
    }
    triangle {
        F, D, C
        YellowTexture ()
    }
    triangle {
        F, C, B
        RedTexture ()
    }
    triangle {
        F, B, E
        BlueTexture ()
    }
}
#end

//AsteroidGrid (10, 0.0, 0.0, 0.0 + Distance)
AsteroidGrid (10, 5.0, 0.0, 0.0 + Distance)
AsteroidGrid (10, -5.0, 0.0, 0.0 + Distance)

Station (0.5, 0.0, 2.0, 11.0 + Distance)
Station (0.5, 0.0, -2.0, 11.0 + Distance)
Station (0.5, -5.0, 0.5, 6.0 + Distance)
Station (0.5, -1.0, -0.5, 6.0 + Distance)
Station (0.5, 3.0, 0.0, 6.0 + Distance)

union {
    #local X1 = 0.0;
    #local Y1 = 0.0;
    sphere { < X1, Y1, LTZ (X1, Y1, 11.0 + Distance) >, 0.5
        MagentaTexture ()
    }
    #local X2 = 0.6;
    #local Y2 = 0.6;
    sphere { < X2, Y2, LTZ (X2, Y2, 10.0 + Distance) >, 0.03
        CyanTexture ()
    }
}

