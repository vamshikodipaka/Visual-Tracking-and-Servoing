function x = uthetat2dq( ui, thetai, ti )
%%/////////////////////////////////////////////////////////////////////////
% theta : rotation around an axis
% u : rotation axis
% t : translation 
		
q_rot = [ cos( thetai/2 ); sin( thetai/2 )*ui   ];

q_tr = 0.5*mulpq( [0; ti], q_rot );

x = [ q_rot; q_tr ];
end
