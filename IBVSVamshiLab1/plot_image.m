function plot_image( img_pointsim, fillim )
%%/////////////////////////////////////////////////////////////////////////
if(fillim == 1)
    plot( img_pointsim(1,1), img_pointsim(2,1), 'ro' , 'MarkerSize', 10, 'MarkerFaceColor', 'r' );
    plot( img_pointsim(1,2), img_pointsim(2,2), 'go' , 'MarkerSize', 10, 'MarkerFaceColor', 'g' );
    plot( img_pointsim(1,3), img_pointsim(2,3), 'bo' , 'MarkerSize', 10, 'MarkerFaceColor', 'b' );
    plot( img_pointsim(1,4), img_pointsim(2,4), 'ko' , 'MarkerSize', 10, 'MarkerFaceColor', 'k' );
else
    plot( img_pointsim(1,1), img_pointsim(2,1), 'ro' , 'MarkerSize', 12, 'LineWidth', 2 );
    plot( img_pointsim(1,2), img_pointsim(2,2), 'go' , 'MarkerSize', 12, 'LineWidth', 2 );
    plot( img_pointsim(1,3), img_pointsim(2,3), 'bo' , 'MarkerSize', 12, 'LineWidth', 2 );
    plot( img_pointsim(1,4), img_pointsim(2,4), 'ko' , 'MarkerSize', 12, 'LineWidth', 2 );
end    
    