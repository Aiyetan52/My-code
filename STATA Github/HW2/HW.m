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

Resid = X*b - Log_Erns; 


%Section Two: Construct M_Hat Covariance Matrix
J=max(Group);


C=zeros(J);
I=zeros(J);



for k=1:J
    for i=1:J
        I(k,i)=sum(and(Group==k,Date==(2003+J)));  
    end
end

for k=1:J
    for i=1:J
            C(k,i)=(1/I(k,i))*(Resid(and((Group==k),Date==2003+J))'*Resid(and(Group==(k),Date==(2003+J))));
        end
    end
M=vech(C(k,i));

%Section 3: Min Distance Estimation of Theta
sigma_alpha=sqrt(0.013); %Initial guess for sigma_alpha
sigma_nu=sqrt(0.030); %Initial guess for sigma_nu
sigma_epsilon=sqrt(0.020); %Assumed values for sigma_epsilon
rho=.5; % Assumed values sigma_rho

theta=[sigma_alpha,sigma_nu,sigma_epsilon,rho]'; %Generate vector to pass to fminsearch

M_Theta=zeros(J,J);

M_Theta=[sigma_alpha+sigma_epsilon+sigma_nu, sigma_alpha+rho*sigma_nu;
    sigma_alpha+rho*sigma_nu, sigma_alpha+sigma_epsilon+sigma_nu];

M_Theta_Bar=M_Theta(:);



d=Dist_Function(theta,M); 





%Unconstrained Minimization
fun = @(theta) Dist_Function(theta,M); %import function
theta_min=fminsearch(fun,theta); %Solve the minimum distance problem, unconstrained

%Unconstrained Minimization
A=[-1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,-1]';   
b=[0,0,0,0];
theta_min_con=fmincon(fun,theta,A,b); %Solve the minimum distance problem, constrained to positive values


%Section 4: Discretize Income Process
sigma_alpha=theta_min(1);
sigma_nu=theta_min(2);
sigma_epsilon=theta_min(3);
rho=theta_min(4);


sigma_z= sigma_epsilon/(1-rho^2);
n=10;
m=3;
Pi=zeros(3);


Z_one=-m*sigma_z;
Z_n=m*sigma_z;
dz=(Z_n-Z_one)/(n-1);

Z=[Z_one:dz:0:dz:Z_n];



for i=1:n
    for k=1:n
        Pi(i,k)=normcdf((Z(i)+(dz/2)-rho*Z(k))/sigma_epsilon)-normcdf((Z(i)-(dz/2)-rho*Z(k))/sigma_epsilon);

    end
end


