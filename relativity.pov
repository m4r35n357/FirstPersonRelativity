#version 3.7;
#include "colors.inc"

#declare V = 0.9;
#debug concat("V: ", str(V,3,2))
#declare GAMMA = 1.0 / sqrt(1.0 - V*V);
#debug concat(", GAMMA: ", str(GAMMA,3,3))

#declare Distance = 10.0 * (0.5 - clock);
#debug concat(", Distance: ", str(Distance,3,1))
#declare Time = Distance / V;
#debug concat(", Time: ", str(Time,3,1))
#declare Tau = Time / GAMMA;
#debug concat(", Proper Time: ", str(Tau,3,1), "\n")

global_settings { assumed_gamma 1.8 }

light_source { <1, 1, 0> color White }

camera {
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 120.0
  look_at < 0.0, 0.0, 100 >
}

#declare LorentzZ = function (X, Y, Z) {
    GAMMA * (Z + V * sqrt(X*X + Y*Y + Z*Z))
}

union {
    #declare Size = 4;
    #declare Centre = (Size - 1.0) / 2.0;
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
                sphere { < X, Y, LorentzZ (X, Y, Z) >, 0.05
                    texture {
                        pigment {
                            #if ( NrZ = 0 ) color rgb < 1, 0, 0 > #end
                            #if ( NrZ = 1 ) color rgb < 0.7, 0.7, 0 > #end
                            #if ( NrZ = 2 ) color rgb < 0, 1, 0 > #end
                            #if ( NrZ = 3 ) color rgb < 0, 0, 1 > #end
                        }
                        finish {
                            phong 1
                        }
                    }
                }
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 1;
    #end
}

