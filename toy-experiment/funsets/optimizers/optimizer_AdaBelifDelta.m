function o_new = optimizer_AdaBelifDelta(o_old,r1,r2,loop)
    o_new = o_old;
    
    eps_ = 1e-5;

    o_new.mom1 = r1 * o_old.mom1 + (1 - r1) * o_old.grad;
    o_new.mom2 = r2 * o_old.mom2 + (1 - r2) * abs(o_old.mom1 - ...
                                                  o_old.grad).^2;
        
    m1 = o_new.mom1/(1 - r1^loop);
    m2 = o_new.mom2/(1 - r2^loop);
    new_grad =  (sqrt(o_old.step) + eps_)./ (sqrt(m2) + eps_) .*...
                                  (r1 * m1 + (1 - r1) * o_old.grad);

    o_new.value = o_old.value - new_grad; 

    o_new.step = r1 *o_old.step + (1 - r1) * abs(new_grad).^2;
end