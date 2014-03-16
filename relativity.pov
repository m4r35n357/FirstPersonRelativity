#version 3.7;
#include "colors.inc"

#declare V = 0.8;
#declare GAMMA = 1.0 / sqrt(1.0 - V*V);

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

#declare Ball = 
    sphere { < 0, 0, 0 >, 0.05
        scale < 1, 1, 1 >
        texture {
            pigment {
                color rgb < 1, 0.1, 0 >
            }
            finish {
                phong 1
            }
        }
        rotate<0,0,0>
        translate<0,0,0>
    }

union {
    #local NrX = 0;    // start x
    #local EndNrX = 4; // end   x
    #while (NrX < EndNrX) 
        #local NrY = 0;    // start y 
        #local EndNrY = 4; // end    y
        #while (NrY < EndNrY) 
            #local NrZ = 0;     // start z
            #local EndNrZ = 4; // end   z
            #while (NrZ < EndNrZ) 
                #local X = NrX - cameraX;
                #local Y = NrY - cameraY;
                #local Z = NrZ - cameraZ;
                object { Ball
                    translate < NrX, NrY, NrZ >
                    matrix < 1.0, 0.0, 0.0,
                        0.0, 1.0, 0.0,
                        0.0, 0.0, GAMMA,
                        0.0, 0.0, GAMMA*V*sqrt(X*X + Y*Y + Z*Z) >
                }
            #local NrZ = NrZ + 1;  // next Nr z
            #end // --------------- end of loop z
        #local NrY = NrY + 1;  // next Nr y
        #end // --------------- end of loop y
    #local NrX = NrX + 1;  // next Nr x
    #end // --------------- end of loop x
}

