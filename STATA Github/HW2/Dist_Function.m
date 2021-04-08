function d=Dist_Function(theta,M)
    
    
    
    M_Theta=[theta(1) + theta(3) + theta(2), theta(1)+(theta(4)*theta(2));
     theta(1)+(theta(4)*theta(2)), theta(1)+theta(3)+theta(2)];
    
    M_Theta_Bar=M_Theta(:);
   
    
    d=((M_Theta_Bar-M)')*(M_Theta_Bar-M);

    
end


