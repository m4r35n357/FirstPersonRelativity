#version 3.7;

#include "colors.inc"
#include "./macros.inc"

#if (AccelerationMode > 0.0)
    #declare TotalTau = 2.0 * acosh(A * 0.5 * TotalDZ + 1.0) / A;
    #declare Tau = clock * TotalTau;
    #if (Tau <= 0.5 * TotalTau)
        #declare DZ = (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = tanh(A * Tau);
    #else
        #declare Aut = TotalTau - Tau;
        #declare DZ = TotalDZ - (cosh(A * Aut) - 1.0) / A;
        #declare Time = (2.0 * sinh(0.5 * A * TotalTau) - sinh(A * Aut)) / A;
        #declare V = tanh(A * Aut);
    #end
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
#else  // constant velocity mode
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
    #declare DZ = TotalDZ * clock;
    #declare Time = DZ / V;
    #declare Tau = Time / GAMMA;
#end

#debug concat("tau: ", str(Tau,3,3))
#debug concat(", v: ", str(V,3,3))
#debug concat(", gamma: ", str(GAMMA,3,3))
#debug concat(", t: ", str(Time,3,3))
#debug concat(", z: ", str(DZ,3,3), "\n")

#macro LorentzZ (X, Y, Z)
    #local newZ = Z - DZ;
    < X, Y, GAMMA * (newZ + V * sqrt(X * X + Y * Y + newZ * newZ)) >
#end

#macro Doppler (X, Y, Z, Hue)
    #local DF = (1.0 + V * cos(atan2(sqrt(X * X + Y * Y), Z - DZ))) * GAMMA;
    #if (DF >= 1.0)  // blue shift, lighten
        CHSL2RGB(< 330.0 - (330.0 - Hue) / DF, 1.0, 1.0 - 0.5 / (DF * DF) >)
    #else  // red shift, darken
        CHSL2RGB(< Hue * DF, 1.0, 0.5 * DF * DF >)
    #end
#end

global_settings { assumed_gamma 1.8 }

light_source { LorentzZ(0, 0, 0) colour White shadowless }

camera {
  up < 0, 1, 0 >
  right < 1, 0, 0 >
  location < 0.0, 0.0, 0.0 >
  angle 120.0
  #if (LookForward > 0.0)
    look_at < 0.0, 0.0, 100.0 >
  #else  // look left
    look_at < -100.0, 0.0, 0.0 >
  #end
}

#declare X = Horizontal;
#while (X >= - Horizontal)
    Milestones(X, -0.05, 0.0, TotalDZ + 5.0)
    #local X = X - 0.25;
#end

#include "./scenery.inc"
#include "./rings.inc"

