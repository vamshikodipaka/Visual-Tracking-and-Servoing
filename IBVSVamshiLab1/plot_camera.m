function plot_camera( pose_camin, colorin )
%%/////////////////////////////////////////////////////////////////////////
p1in = [  0.05;  0.05; 0 ];
p2in = [  0.05; -0.05; 0 ];
p3in = [ -0.05; -0.05; 0 ];
p4 = [ -0.05;  0.05; 0 ];


L = 0.15;
z = [0; 0; 1];

p5 = p1in + L*z;
p6 = p2in + L*z;
p7 = p3in + L*z;
p8 = p4 + L*z;

a = L*z;
b = [  0.025;  0.025; 0 ] + 1.2*a;
c = [  0.025; -0.025; 0 ] + 1.2*a;
d = [ -0.025; -0.025; 0 ] + 1.2*a;
e = [ -0.025;  0.025; 0 ] + 1.2*a;

%% move camera to a given pose
cam_points = pose_camin*[ p1in, p2in, p3in, p4, p5, p6, p7, p8, a, b, c, d, e; ones(1,13)];
p1in = cam_points(1:3,1);  
p2in = cam_points(1:3,2);
p3in = cam_points(1:3,3);
p4 = cam_points(1:3,4);

p5 = cam_points(1:3,5);
p6 = cam_points(1:3,6);
p7 = cam_points(1:3,7);
p8 = cam_points(1:3,8);

a = cam_points(1:3,9);
b = cam_points(1:3,10);
c = cam_points(1:3,11);
d = cam_points(1:3,12);
e = cam_points(1:3,13);


%% plot camera
plot_plane( p1in, p2in, p3in, p4, colorin );
plot_plane( p5, p6, p7, p8, colorin );
plot_plane( p1in, p5, p8, p4, colorin );
plot_plane( p2in, p3in, p7, p6, colorin );

plot_triangle( a, b, c, colorin );
plot_triangle( a, d, e, colorin );
plot_plane( b, c, d, e, colorin );






