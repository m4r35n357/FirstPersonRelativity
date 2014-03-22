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

camera {
  fisheye
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 180.0
  look_at < 0.0, 0.0, 100 >
}

union {
    #local Size = 10;
    #local Centre = (Size - 1.0) / 2.0;
    #local NrZ = 0;
    #local EndNrZ = Size;
    #while (NrZ < EndNrZ) 
        #local NrY = 0;
        #local EndNrY = Size;
        #while (NrY < EndNrY) 
            #local NrX = 0;
            #local EndNrX = Size;
            #while (NrX < EndNrX) 
                #local X = NrX - Centre;
                #local Y = NrY - Centre;
                #local Z = NrZ - Centre + Distance;
                #if ( mod(NrX, 3) = 0 | mod(NrY, 3) = 0 )
                    sphere { < X, Y, LTZ (X, Y, Z) >, 0.05
                        texture {
                            pigment {
                                #if ( NrZ = 0 ) color rgb < 1.0, 0.0, 0.0 > #end
                                #if ( NrZ = 3 ) color rgb < 0.7, 0.7, 0.0 > #end
                                #if ( NrZ = 6 ) color rgb < 0.0, 1.0, 0.0 > #end
                                #if ( NrZ = 9 ) color rgb < 0.0, 0.0, 1.0 > #end
                            }
                            finish {
                                phong 1
                            }
                        }
                    }
                #end
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 3;
    #end
    #local X1 = 0.0;
    #local Y1 = 0.0;
    sphere { < X1, Y1, LTZ (X1, Y1, 10.01) >, 0.5
        texture {
            pigment {
                color rgb < 0.7, 0.0, 0.7 >
            }
        }
    }
    #local X2 = 1.0;
    #local Y2 = 1.0;
    sphere { < X2, Y2, LTZ (X2, Y2, 10.0) >, 0.1
        texture {
            pigment {
                color rgb < 0.0, 1.0, 1.0 >
            }
        }
    }
}

