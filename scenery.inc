
AsteroidGrid(10, 0.0, 0.0, 0.5 * TotalZ)

#local X = -100.0;
#local Y = 40.0;
#local Z = TotalZ + 200.0;
#local SunZ = LorentzZ(X, Y, Z);
light_source { SunZ colour White shadowless }
sphere { SunZ, 10.0 HSLTexture(X, Y, Z, HOrange) }
//Icosohedron(10.0, X, - Y, Z)

#local X = 0.0;
#local Y = 0.0;
#local Z = TotalZ + 1.0;
Icosohedron(0.5, X, Y, Z)

#local X = 0.3;
#local Y = 0.3;
#local Z = TotalZ + 0.5;
sphere { LorentzZ(X, Y, Z), 0.01 HSLTexture(X, Y, Z, HLime) }

//#declare Z = 0;
//#while (Z <= 20)
//    Icosohedron(0.25, -1.0, 0.0, Z)
//    #local Z = Z + 1;
//#end

Icosohedron(0.5, 0.0, 0.0, 21.0)

