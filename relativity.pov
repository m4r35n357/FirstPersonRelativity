#version 3.7;

#include "colors.inc"
#include "./macros.inc"

#if (AccelerationMode > 0.0)
    #declare Z0 = 0.5 * TotalDZ;
    #declare Tau0 = acosh(A * Z0 + 1.0) / A;
    #declare T0 = sinh(A * Tau0) / A;
    #declare V0 = tanh(A * Tau0);
    #declare Tau = 4.0 * Tau0 * clock;
    #if (Tau <= Tau0)
        #declare DZ = (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = tanh(A * Tau);
    #else
        #if (Tau <= 2.0 * Tau0)
            #declare Aut = 2.0 * Tau0 - Tau;
            #declare DZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
            #declare Time = 2.0 * T0 - sinh(A * Aut) / A;
            #declare V = tanh(A * Aut);
        #else
            #if (Tau <= 3.0 * Tau0)
                #declare Aut = Tau - 2.0 * Tau0;
                #declare DZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
                #declare Time = 2.0 * T0 + sinh(A * Aut) / A;
                #declare V = - tanh(A * Aut);
            #else
                #declare Aut = 4.0 * Tau0 - Tau;
                #declare DZ = (cosh(A * Aut) - 1.0) / A;
                #declare Time = 4.0 * T0 - sinh(A * Aut) / A;
                #declare V = - tanh(A * Aut);
            #end
        #end
    #end
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
#else  // constant velocity mode
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
    #declare DZ = TotalDZ * clock;
    #declare Time = DZ / V;
    #declare Tau = Time / GAMMA;
#end

#macro LorentzZ (X, Y, Z)
    #local newZ = Z - DZ;
    < X, Y, GAMMA * (newZ + V * LightDelay (X, Y, newZ)) >
#end

#macro LightDelay (X, Y, Z)
    sqrt(X * X + Y * Y + Z * Z)
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
    Milestones(X, - 0.05, 0.0, TotalDZ + 5.0)
    #local X = X - 0.25;
#end

#include "./scenery.inc"
#include "./rings.inc"

#debug concat("tau: ", str(Tau,3,3))
#debug concat(", TS: ", str(Time - LightDelay(0.0, 0.0, DZ),3,3))
#debug concat(", TD: ", str(Time - LightDelay(0.0, 0.0, TotalDZ - DZ),3,3))
//#debug concat(", v: ", str(V,3,3))
//#debug concat(", gamma: ", str(GAMMA,3,3))
#debug concat(", t: ", str(Time,3,3))
#debug concat(", z: ", str(DZ,3,3))
#debug concat("\n")

