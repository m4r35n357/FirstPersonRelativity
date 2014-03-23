#version 3.7;
//#include "colors.inc"
#include "./macros.inc"

#if (false)
    #declare V = 0.0;
    #declare Distance = 20.0 * (0.5 - clock);
    #declare Time = Distance / V;
    #declare GAMMA = 1.0 / sqrt(1.0 - V*V);
    #declare Tau = Time / GAMMA;
#else
    #declare A = 1.0;
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
    GAMMA * (Z + Distance + V * sqrt(X*X + Y*Y + (Z + Distance)*(Z + Distance)))
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

AsteroidGrid (10, 5.0, 0.0, 0.0)
AsteroidGrid (10, -5.0, 0.0, 0.0)

Station (0.25, 0.0, 2.0, 11.0)
Station (0.25, 0.0, -2.0, 11.0)
Station (0.25, -5.0, 0.5, 6.0)
Station (0.25, -1.0, -0.5, 6.0)
Station (0.25, 3.0, 0.0, 6.0)

union {
    #local X1 = 0.0;
    #local Y1 = 0.0;
    sphere { < X1, Y1, LTZ (X1, Y1, 11.0) >, 0.5 BlueTexture() }
    #local X2 = 0.6;
    #local Y2 = 0.6;
    sphere { < X2, Y2, LTZ (X2, Y2, 10.0) >, 0.03 MagentaTexture() }
}

