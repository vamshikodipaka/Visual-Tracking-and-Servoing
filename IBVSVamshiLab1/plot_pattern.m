function plot_pattern( pattern )
	%%/////////////////////////////////////////////////////////////////////////
p1in = pattern(:,1);
p2in = pattern(:,2);
p3in = pattern(:,3);
p4in = pattern(:,4);


plot3( p1in(1),  p1in(2),  p1in(3),  'ro',  'MarkerSize', 8, 'MarkerFaceColor', 'r' );
plot3( p2in(1),  p2in(2),  p2in(3),  'go',  'MarkerSize', 8, 'MarkerFaceColor', 'g' );
plot3( p3in(1),  p3in(2),  p3in(3),  'bo',  'MarkerSize', 8, 'MarkerFaceColor', 'b' );
plot3( p4in(1),  p4in(2),  p4in(3),  'ko',  'MarkerSize', 8, 'MarkerFaceColor', 'k' );


c1 = pattern(:,5);
c2 = pattern(:,6);
c3 = pattern(:,7);
c4 = pattern(:,8);

plot3( [ c1(1)  c2(1)  c3(1)  c4(1) c1(1)  ],   [ c1(2)  c2(2)  c3(2)  c4(2) c1(2)  ],  [ c1(3)  c2(3)  c3(3)  c4(3) c1(3) ],  'k-' , 'LineWidth', 2  );