
AsteroidGrid (10, 0.0, 0.0, 0.5 * TotalDZ)

#local X = -100.0;
#local Y = 40.0;
#local Z = TotalDZ + 200.0;
#local SunZ = LorentzZ(X, Y, Z);
light_source { SunZ color White shadowless }
sphere { SunZ, 10.0 HSLTexture(X, Y, Z, HOrange) }

#local X = 0.0;
#local Y = 0.0;
#local Z = TotalDZ + 1.0;
sphere { LorentzZ(X, Y, Z), 0.5 HSLTexture(X, Y, Z, HRed) }

#local X = 0.3;
#local Y = 0.3;
#local Z = TotalDZ + 0.5;
sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HLime) }

