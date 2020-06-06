function s = skew( uin )
	
s = [ 0, -uin(3),  uin(2);  
        uin(3),  0,   -uin(1);
        -uin(2),  uin(1),  0];
end