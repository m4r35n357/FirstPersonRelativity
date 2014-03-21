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

#declare cubeSize = 4;
#declare cubeCentre = (cubeSize - 1.0) / 2.0;

global_settings { assumed_gamma 1.8 }

light_source { <1, 1, 0> color White }

camera {
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 120.0
  look_at < 0.0, 0.0, 100 >
}

#macro Lorentz_Transform (X, Y, Z)
                    translate < X, Y, Z >
                    matrix < 1.0, 0.0, 0.0,
                        0.0, 1.0, 0.0,
                        0.0, 0.0, GAMMA,
                        0.0, 0.0, GAMMA * V * sqrt(X*X + Y*Y + Z*Z) >
#end

union {
    #local NrZ = 0;
    #local EndNrZ = cubeSize;
    #while (NrZ < EndNrZ) 
        #local NrY = 0;
        #local EndNrY = cubeSize;
        #while (NrY < EndNrY) 
            #local NrX = 0;
            #local EndNrX = cubeSize;
            #while (NrX < EndNrX) 
                sphere { < 0, 0, 0 >, 0.05
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
                    Lorentz_Transform (NrX - cubeCentre, NrY - cubeCentre, NrZ - cubeCentre + Distance)
                }
                #local NrX = NrX + 1;
            #end
            #local NrY = NrY + 1;
        #end
        #local NrZ = NrZ + 1;
    #end
}

