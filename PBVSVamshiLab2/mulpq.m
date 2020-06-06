function x = mulpq( pin, qin )
	%%/////////////////////////////////////////////////////////////////////////
s1i = pin(1);
v1i = pin(2:4);

s2i = qin(1);
v2i = qin(2:4);

x = [  s1i*s2i - v1i'*v2i;  s1i*v2i + s2i*v1i + cross( v1i, v2i )  ];

end