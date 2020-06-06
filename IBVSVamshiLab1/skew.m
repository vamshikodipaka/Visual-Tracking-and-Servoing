function s = skew( ui )
	
s = [ 0, -ui(3),  ui(2);  
        ui(3),  0,   -ui(1);
        -ui(2),  ui(1),  0];
