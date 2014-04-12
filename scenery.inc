
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

#local X0 = -50.0;
#local Y0 = 20.0;
#local Z0 = LTZ (X0, Y0, 200.0);
light_source { <X0, Y0, Z0> color White }
sphere { < X0, Y0, Z0 >, 10.0 OrangeTexture() }

#local X1 = 0.0;
#local Y1 = 0.0;
sphere { < X1, Y1, LTZ (X1, Y1, 21.0) >, 0.5 BlueTexture() }

#local X2 = 0.8;
#local Y2 = 0.6;
sphere { < X2, Y2, LTZ (X2, Y2, 20.0) >, 0.01 MagentaTexture() }

