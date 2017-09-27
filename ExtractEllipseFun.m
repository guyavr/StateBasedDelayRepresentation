function eqt = ExtractEllipseFun(A)

%Convert the A to str
a = num2str(A(1)); 
b = num2str(A(2)); 
c = num2str(A(3)); 
d = num2str(A(4)); 
e = num2str(A(5)); 
f = num2str(A(6));

eqt= ['(',a, ')*x^2 + (',b,')*x*y + (',c,')*y^2 + (',d,')*x+ (',e,')*y + (',f,')'];

end % ExtractEllipseFun