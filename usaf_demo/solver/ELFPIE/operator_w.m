function out = operator_w(o,fun_d,type)

if strcmp(type,'isotropic')
    hold_x = fun_d{1,1}(o);
    hold_y = fun_d{2,1}(o);
    den = sqrt(hold_y.^2 + hold_x.^2) + eps;
    out = fun_d{1,2}(hold_x./den) + fun_d{2,2}(hold_y./den);
elseif strcmp(type,'anisotropic')    
    hold_x = sign(fun_d{1,1}(o));
    hold_y = sign(fun_d{2,1}(o));
    out = fun_d{1,2}(hold_x) + fun_d{2,2}(hold_y);
else
    error("parameter #3 should be a string either 'isotropic', or 'anisotropic'")
end

end