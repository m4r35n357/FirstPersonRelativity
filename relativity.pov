#version 3.7;

#include "colors.inc"
#include "./macros.inc"

#if (AccelerationMode > 0.0)
    #declare Z0 = 0.5 * TotalZ;
    #declare Tau0 = acosh(A * Z0 + 1.0) / A;
    #declare T0 = sinh(A * Tau0) / A;
    #declare Tau = 4.0 * Tau0 * clock;
    #if (clock <= 0.25)
        #declare dZ = (cosh(A * Tau) - 1.0) / A;
        #declare Time = sinh(A * Tau) / A;
        #declare V = - tanh(A * Tau);
    #else
        #if (clock <= 0.5)
            #declare Aut = 2.0 * Tau0 - Tau;
            #declare dZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
            #declare Time = 2.0 * T0 - sinh(A * Aut) / A;
            #declare V = - tanh(A * Aut);
        #else
            #if (clock <= 0.75)
                #declare Aut = Tau - 2.0 * Tau0;
                #declare dZ = 2.0 * Z0 - (cosh(A * Aut) - 1.0) / A;
                #declare Time = 2.0 * T0 + sinh(A * Aut) / A;
                #declare V = tanh(A * Aut);
            #else
                #declare Aut = 4.0 * Tau0 - Tau;
                #declare dZ = (cosh(A * Aut) - 1.0) / A;
                #declare Time = 4.0 * T0 - sinh(A * Aut) / A;
                #declare V = tanh(A * Aut);
            #end
        #end
    #end
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
#else  // constant velocity mode
    #declare GAMMA = 1.0 / sqrt(1.0 - V * V);
    #if (V > 0.0)
        #declare T0 = TotalZ / V;
        #declare Time = 2.0 * TotalZ / V * clock;
    #else
        #declare T0 = TotalZ;
        #declare Time = 4.0 * T0 * clock;
    #end
    #declare Tau = Time / GAMMA;
    #if (clock <= 0.5)
        #declare dZ = 2.0 * TotalZ * clock;
        #declare V = - V;
    #else 
        #declare dZ = TotalZ - 2.0 * TotalZ * (clock - 0.5);
    #end
#end
#if (Reverse > 0.0)
    #declare dZ = TotalZ - dZ;
    #declare V = -V;
#end

#macro Delay (X, Y, Z)
    sqrt(X * X + Y * Y + Z * Z)
#end

#macro LorentzZ (X, Y, Z)  // Special Relativity happens here . . .
    <X, Y, GAMMA * (Z - dZ - V * Delay(X, Y, Z - dZ))>
#end

#macro LorentzT (X, Y, Z)  // . . . and here!
    GAMMA * (Delay(X, Y, Z - dZ) - V * (Z - dZ))
#end

#macro Doppler (X, Y, Z, Hue)
    #local DF = LorentzT(X, Y, Z) / Delay(X, Y, Z - dZ);
    #if (DF >= 1.0)  // blue shift, lighten
        CHSL2RGB(<260.0 - (260.0 - Hue) / DF, 1.0, 1.0 - 0.5 / DF>)
    #else  // red shift, darken
        CHSL2RGB(<Hue * DF, 1.0, 0.5 * DF>)
    #end
#end

global_settings { assumed_gamma 1.0 }

light_source { <1, 1, 0> colour White shadowless }

camera {
  up <0, 0.9, 0>
  right <1.6, 0, 0>
  location <0.0, 0.0, 0.0>
  angle 120.0
  #if (LookForward > 0.0)
    look_at <0, 0, 1>
  #else  // look left
    look_at <-1, 0, 0>
  #end
}

#include "./scenery.inc"

#debug concat("tau: ", str(Tau,3,3))
#debug concat(", TS: ", str(Time - Delay(1.0, 0.0, - dZ),3,3))
#debug concat(", TD: ", str(Time - Delay(1.0, 0.0, TotalZ - dZ),3,3))
#debug concat(", t: ", str(Time,3,3))
#debug concat(", z: ", str(dZ,3,3))
#debug concat(", TH: ", str(Time + Delay(0.0, 0.0, dZ),3,3))
#debug concat(", T1: ", str(Time - Delay(1.0, 0.0, 0.1 * TotalZ - dZ),3,3))
#debug concat(", T2: ", str(Time - Delay(1.0, 0.0, 0.2 * TotalZ - dZ),3,3))
#debug concat(", T3: ", str(Time - Delay(1.0, 0.0, 0.3 * TotalZ - dZ),3,3))
#debug concat(", T4: ", str(Time - Delay(1.0, 0.0, 0.4 * TotalZ - dZ),3,3))
#debug concat(", T5: ", str(Time - Delay(1.0, 0.0, 0.5 * TotalZ - dZ),3,3))
#debug concat(", T6: ", str(Time - Delay(1.0, 0.0, 0.6 * TotalZ - dZ),3,3))
#debug concat(", T7: ", str(Time - Delay(1.0, 0.0, 0.7 * TotalZ - dZ),3,3))
#debug concat(", T8: ", str(Time - Delay(1.0, 0.0, 0.8 * TotalZ - dZ),3,3))
#debug concat(", T9: ", str(Time - Delay(1.0, 0.0, 0.9 * TotalZ - dZ),3,3))
//#debug concat(", v: ", str(V,3,3))
//#debug concat(", gamma: ", str(GAMMA,3,3))
#debug concat("\n")

