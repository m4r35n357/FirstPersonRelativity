#version 3.7;
#include "colors.inc"

#declare V = 0.9;
//#declare V = clock;
#declare GAMMA = 1.0 / sqrt(1.0 - V*V);

#debug concat("V: ", str(V,3,2))
#debug concat(", GAMMA: ", str(GAMMA,3,3))

#declare Distance = 20.0;
#declare cameraX = 1.5;
#declare cameraY = 1.5;
//#declare cameraZ = 1.5 - Distance / 2.0 + clock * Distance;
#declare cameraZ = 1.5 - 0.2 * Distance + clock * (Distance);

#debug concat(", X: ", str(cameraX,3,1))
#debug concat(", Y: ", str(cameraY,3,1))
#debug concat(", Z: ", str(cameraZ,3,1), "\n")

global_settings { assumed_gamma 1.8 }

light_source { <cameraX+1, cameraY+1, cameraZ> color White }
light_source { <cameraX-1, cameraY-1, cameraZ> color White }

camera {
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < cameraX, cameraY, cameraZ >
  angle 120.0
  look_at < cameraX, cameraY, Distance >
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
                    matrix < 1.0, 0.0, 0.0,
                        0.0, 1.0, 0.0,
                        0.0, 0.0, GAMMA,
                        NrX, NrY, NrZ + GAMMA * V * sqrt(X*X + Y*Y + Z*Z) >
//                        0.0, 0.0, GAMMA * V * sqrt(X*X + Y*Y + Z*Z) >
//                    translate < NrX, NrY, NrZ >
                }
            #local NrX = NrX + 1;
            #end
        #local NrY = NrY + 1;
        #end
    #local NrZ = NrZ + 1;
    #end
}

