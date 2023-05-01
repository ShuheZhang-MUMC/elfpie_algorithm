function o_new = optimizer_Adam(o_old,r1,r2,loop)
    o_new = o_old;
    
    eps_ = 1e-5;

    o_new.mom1 = r1 * o_old.mom1 + (1 - r1) * o_old.grad;
    o_new.mom2 = r2 * o_old.mom2 + (1 - r2) * abs(o_old.grad).^2;
        
    m1 = o_new.mom1/(1 - r1^loop);
    m2 = o_new.mom2/(1 - r2^loop);

    new_grad =  m1./ (sqrt(m2) + eps_);

    o_new.value = o_old.value - o_new.step .* new_grad; 
end