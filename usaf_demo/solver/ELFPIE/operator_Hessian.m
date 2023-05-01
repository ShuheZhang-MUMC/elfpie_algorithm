function out = operator_Hessian(temp_o)
%     g = fspecial('gaussian',[51,51],25);
    TV_xx = conv2(temp_o,[1,-2,1],'same');
    TV_yy = conv2(temp_o,[1;-2;1],'same');
    TV_xy = conv2(temp_o,[1,-1;-1,1],'same');
    
%     sss = sqrt(TV_xx.^2 + TV_yy.^2 + 2 * TV_xy.^2) + eps;
    out = conv2(sign(TV_xx),[1,-2,1],'same')+...
          conv2(sign(TV_yy),[1;-2;1],'same')+...
       2* conv2(sign(TV_xy),[0,0,0;0,1,-1;0,-1,1],'same');
end