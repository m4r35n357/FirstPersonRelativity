#version 3.7;
#include "./macros.inc"

#if (false)
    #declare V = 0.0;
    #declare Distance = 20.0 * (0.5 - clock);
    #declare Time = Distance / V;
    #declare GAMMA = 1.0 / sqrt(1.0 - V*V);
    #declare Tau = Time / GAMMA;
#else
    #declare A = 1.0;
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

#debug concat("> V: ", str(V,3,3))
#debug concat(", GAMMA: ", str(GAMMA,3,3))
#debug concat(", Distance: ", str(Distance,3,1))
#debug concat(", Time: ", str(Time,3,1))
#debug concat(", Proper Time: ", str(Tau,3,1), " <\n")

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
  #if (false)
    look_at < 0.0, 0.0, 100.0 >
  #else
    look_at < -100.0, 0.0, 0.0 >
  #end
}

Milestones (-0.5, 0.0, -10, 10)

//#include "./scenery.inc"

