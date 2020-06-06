function x = muldualpq( pin, qin )
	%%/////////////////////////////////////////////////////////////////////////
p1i = pin(1:4);
p2i = pin(5:8);

q1i = qin(1:4);
q2i = qin(5:8);

x = [ mulpq( p1i, q1i );  mulpq( p1i, q2i )  + mulpq( p2i, q1i )  ];
end