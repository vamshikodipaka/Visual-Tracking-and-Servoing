function plot_triangle( p1in, p2in, p3in, color )

x = [p1in(1); p2in(1); p3in(1); p1in(1) ];
y = [p1in(2); p2in(2); p3in(2); p1in(2) ];
z = [p1in(3); p2in(3); p3in(3); p1in(3) ];

plot3( x, y, z, color );