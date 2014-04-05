#version 3.7;
#include "./macros.inc"

#if (false)
    #declare V = 0.0;
    #declare Distance = 20.0 * (0.5 - clock);
    #declare Time = Distance / V;
    #declare GAMMA = 1.0 / sqrt(1.0 - V*V);
    #declare Tau = Time / GAMMA;
#else
    #declare A = 0.001;
    #declare StartD = 10.0;
    #declare TotalTau = 2.0 * acosh(A * StartD + 1.0) / A;
    #declare HalfTau = TotalTau / 2.0;
    #declare Tau = clock * TotalTau;
    #if (Tau <= HalfTau)
        #declare Distance = StartD - (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = tanh(A * Tau);
    #else
        #declare Aut = TotalTau - Tau;
        #declare Distance = - StartD + (cosh(A * Aut) - 1.0) / A;
        #declare Time = (2.0 * sinh(A * HalfTau) - sinh(A * Aut)) / A;
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

light_source { <1, 1, 0> color White shadowless }
//light_source { <-1, -1, 0> color White shadowless }

camera {
  up < 0, 0.9, 0 >
  right < 1.6, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 120.0
  #if (true)
    look_at < 0.0, 0.0, 100.0 >
  #else
    look_at < -100.0, 0.0, 0.0 >
  #end
}

#declare X = -10;
#while (X <= 10)
//    Milestones (X, 1.0, -10, 10)
    Milestones (X, -1.0, -10, 10)
    #local X = X + 1;
#end

AsteroidGrid (10, 0.0, 0.0, 0.0)

Station (0.25, 1.0, 0.0, 0.0)
Station (0.25, -0.5, 0.0, 0.0)

Station (0.25, -5.0, 0.5, 6.0)
Station (0.25, -1.0, -0.5, 6.0)
Station (0.25, 3.0, 0.0, 6.0)

#local X0 = -50.0;
#local Y0 = 20.0;
#local Z0 = LTZ (X0, Y0, 200.0);
light_source { <X0, Y0, Z0> color White }
sphere { < X0, Y0, Z0 >, 10.0 OrangeTexture() }

#local X1 = 0.0;
#local Y1 = 0.0;
sphere { < X1, Y1, LTZ (X1, Y1, 11.0) >, 0.5 BlueTexture() }

#local X2 = 0.8;
#local Y2 = 0.45;
sphere { < X2, Y2, LTZ (X2, Y2, 10.0) >, 0.01 MagentaTexture() }

