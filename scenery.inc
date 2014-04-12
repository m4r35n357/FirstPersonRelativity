
AsteroidGrid (10, 0.0, 0.0, 10.0)

Station (0.25, 1.0, -0.5, 10.0)
Station (0.25, -0.5, 1.0, 10.0)
Station (0.25, 1.0, 0.5, 10.0)
Station (0.25, -0.5, -1.0, 10.0)
Station (0.25, -1.0, 0.5, 10.0)
Station (0.25, 0.5, -1.0, 10.0)
Station (0.25, -1.0, -0.5, 10.0)
Station (0.25, 0.5, 1.0, 10.0)

Station (0.25, -5.0, 0.5, 16.0)
Station (0.25, -1.0, -0.5, 16.0)
Station (0.25, 3.0, 0.0, 16.0)

#local W0 = LorentzZ(-100.0, 40.0, 200.0);
light_source { W0 color White }
sphere { W0, 10.0 HSLTexture(-50.0, 20.0, 200.0, Orange) }
//sphere { W0, 10.0 OrangeTexture() }

sphere { LorentzZ(0.0, 0.0, 21.0), 0.5 HSLTexture(0.0, 0.0, 21.0, Blue) }

sphere { LorentzZ(0.8, 0.6, 20.0), 0.01 HSLTexture(0.8, 0.6, 20.0, Magenta) }

