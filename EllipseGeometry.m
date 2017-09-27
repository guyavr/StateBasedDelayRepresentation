function geo=EllipseGeometry(A,del) 
% according to http://mathworld.wolfram.com/Ellipse.html

a = A(1); 
b = A(2)/2; 
c = A(3); 
d = A(4)/2; 
f = A(5)/2; 
g = A(6);

x0=(c*d-b*f)/(b^2-a*c); % x component of center
y0=(a*f-b*d)/(b^2-a*c); % y component of center

cen=[x0 y0];

sem1=sqrt( (2*(a*f^2+c*d^2+g*b^2-2*b*d*f-a*c*g)) / ((b^2-a*c)*(sqrt((a-c)^2+4*b^2)-(a+c))) ); % semi-major (long axis) length
sem2=sqrt( (2*(a*f^2+c*d^2+g*b^2-2*b*d*f-a*c*g)) / ((b^2-a*c)*(-sqrt((a-c)^2+4*b^2)-(a+c))) ); % semi-minor (short axis) length

semMaj=max(sem1,sem2);
semMin=min(sem1,sem2);

semMin=del; % IMPORTANT- this is not related to the ellipse geometry but has taken form the cross correlation analysis

% counterclockwise angle of rotation from the x-axis to the major axis of the ellipse is
if b==0
    if a<c
        phi=0; 
    else
        phi=0.5*pi;
    end
elseif b>0
    if a<c
        phi=0.5*pi+0.5*(acot((a-c)/(2*b)));
    else
        phi=0.5*(acot((a-c)/(2*b)));
    end
else
    if a<c
        phi=0.5*(acot((a-c)/(2*b)));
    else
        phi=0.5*pi+0.5*(acot((a-c)/(2*b)));
    end
end

slope=tan(phi); % major line slope
ycut=y0-slope*x0; % the point in which the major line cut the y axis

x1=x0-max(semMin,semMaj);
x2=x0+max(semMin,semMaj);

y1=y0+slope*(x1-x0);
y2=y0+slope*(x2-x0);

points2=[x1 x2;y1 y2];

f1 = 'cen';  v1 = cen;
f2 = 'semMaj';  v2 = semMaj;
f3 = 'semMin';  v3 = semMin;
f4 = 'phi';  v4 = phi;
f5 = 'points2';  v5 = points2;
f6 = 'slope';  v6 = slope;
f7 = 'ycut';  v7 = ycut;

geo = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7);
end