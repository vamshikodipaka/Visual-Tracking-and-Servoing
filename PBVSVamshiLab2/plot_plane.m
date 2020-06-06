function plot_plane( p1i, p2i, p3i, p4i, colori )
%%/////////////////////////////////////////////////////////////////////////
x = [p1i(1); p2i(1); p3i(1); p4i(1); p1i(1) ];
y = [p1i(2); p2i(2); p3i(2); p4i(2); p1i(2) ];
z = [p1i(3); p2i(3); p3i(3); p4i(3); p1i(3) ];

plot3( x, y, z, colori );