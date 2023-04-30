function o_new = optimizer_SGD(o_old,r1,r2,loop)
    o_new = o_old;
    o_new.value = o_old.value - 0.001 .* o_old.grad; 
end