
AsteroidGrid (10, 0.0, 0.0, 10.0)

//Station (0.25, 1.0, -0.5, 10.0)
//Station (0.25, -0.5, 1.0, 10.0)
//Station (0.25, 1.0, 0.5, 10.0)
//Station (0.25, -0.5, -1.0, 10.0)
//Station (0.25, -1.0, 0.5, 10.0)
//Station (0.25, 0.5, -1.0, 10.0)
//Station (0.25, -1.0, -0.5, 10.0)
//Station (0.25, 0.5, 1.0, 10.0)

//Station (0.25, -5.0, 0.5, 16.0)
//Station (0.25, -1.0, -0.5, 16.0)
//Station (0.25, 3.0, 0.0, 16.0)

#local X = -100.0;
#local Y = 40.0;
#local Z = 200.0;
light_source { < X, Y, Z > color White shadowless }
sphere { LorentzZ(X, Y, Z), 10.0 HSLTexture(X, Y, Z, HOrange) }

#local X = 0.0;
#local Y = 0.0;
#local Z = 21.0;
sphere { LorentzZ(X, Y, Z), 0.5 HSLTexture(X, Y, Z, HRed) }

#local X = 0.3;
#local Y = 0.3;
#local Z = 20.5;
sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HLime) }

