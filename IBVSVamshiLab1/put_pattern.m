function pat = put_pattern( posein )
% pat = four points of the pattern	
	
Oi = posein(1:3,4);
xi = posein(1:3,1);
yi = posein(1:3,2);
zi = posein(1:3,3);

d = 0.2;
px = Oi + d*xi;
py = Oi + d*yi;
pxy = Oi + d*xi + d*yi;

poo = Oi - 0.5*d*xi - 0.5*d*yi;
pxx = Oi + 1.5*d*xi - 0.5*d*yi;
pyy = Oi + 1.5*d*yi - 0.5*d*xi;
pxyxy = pxy + 0.5*d*xi + 0.5*d*yi;

pat = [ Oi, px, pxy, py,  poo, pxx, pxyxy, pyy ]; 
