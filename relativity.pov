#version 3.7;
#include "colors.inc"

#declare V = clock;
#declare GAMMA = 1.0 / sqrt(1.0 - V*V);

#debug concat("V: ", str(V,3,2))
#debug concat(", GAMMA: ", str(GAMMA,3,3), "\n")

#declare cameraX = 1.5;
#declare cameraY = 1.5;
#declare cameraZ = 1.5;

global_settings { assumed_gamma 1.8 }

light_source { <cameraX+1, cameraY+1, cameraZ> color White }
light_source { <cameraX-1, cameraY-1, cameraZ> color White }

camera {
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < cameraX, cameraY, cameraZ >
  look_at < cameraX, cameraY, 1000000 >
  angle 120.0
}

union {
    #local NrZ = 0;
    #local EndNrZ = 4;
    #while (NrZ < EndNrZ) 
        #local NrY = 0;
        #local EndNrY = 4;
        #while (NrY < EndNrY) 
            #local NrX = 0;
            #local EndNrX = 4;
            #while (NrX < EndNrX) 
                #local X = NrX - cameraX;
                #local Y = NrY - cameraY;
                #local Z = NrZ - cameraZ;
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
                    translate < NrX, NrY, NrZ >
                    matrix < 1.0, 0.0, 0.0,
                        0.0, 1.0, 0.0,
                        0.0, 0.0, GAMMA,
                        0.0, 0.0, GAMMA*V*sqrt(X*X + Y*Y + Z*Z) >
                }
            #local NrX = NrX + 1;
            #end
        #local NrY = NrY + 1;
        #end
    #local NrZ = NrZ + 1;
    #end
}

