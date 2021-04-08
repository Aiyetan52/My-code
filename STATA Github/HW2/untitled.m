clear
clc
Book1ass = readtable('Book1ass.xlsx');

Obs = table2array(Book1ass(:,1));
Date=table2array(Book1ass(:,2));
Erns = table2array(Book1ass(:,3));
Age = table2array(Book1ass(:,4));
Group = table2array(Book1ass(:,5));

%Section One: Run Regression to obtain Residuals
Log_Erns = log(Erns);
Age_Sq=Age.^2;

X =[ones(size(Age)) Age Age_Sq ]

b=regress(Log_Erns,X)

Resid = -X*b + Log_Erns; 
y=Resid;
z=[ones(size(Age)) Age ]
a=regress(y,z);
w=-z*a+y;
maxLag = 1;
lags = 1:maxLag;
wLags = lagmatrix(w,lags);
s=[ones(size(Age)) Age wLags];
c=regress(y,s);
u=-s*c+y;





s2 = nanmean( u.^2 );

% Compute gradients at each t
g = bsxfun(@times,u,s/s2);



% Compute covariance based on Hessian
h = -s'*s/s2;

