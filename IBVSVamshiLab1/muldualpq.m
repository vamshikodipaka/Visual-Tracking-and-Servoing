function x = muldualpq( pin, qin )
	%%/////////////////////////////////////////////////////////////////////////
p1 = pin(1:4);
p2 = pin(5:8);

q1 = qin(1:4);
q2 = qin(5:8);

x = [ mulpq( p1, q1 );  mulpq( p1, q2 )  + mulpq( p2, q1 )  ];
