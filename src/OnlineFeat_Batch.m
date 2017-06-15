function [ w, F, S ] = OnlineFeat_Batch(X, y, mf, batch_num)
%OS Summary of this function goes here
%   Detailed explanation goes here
    p = size(X, 1);
    n = size(X, 2);
    w = zeros(p, 1);
    F = 1:batch_num;
    F = F';
    S = 1:n;
    
    for i = 2:p/batch_num
        Fn = batch_num*(i-1)+1 : batch_num*i;
        %[w, F] = FeatSelect(X(:,S), y(S), w, mf, F, i);
        [w, F] = FeatSelect(X(:,S), y(S), w, mf, F, Fn, batch_num);
        [w_f, S] = SingleHR(X(F,:), y);
        w(F) = w_f;
    end
    
%     [w_f, S] = SingleHR(X(F,:), y);
%     w(F) = w_f;
end

function [ w, F ] = FeatSelect(X, y, w, mf, F, Fn, batch_num)

    n = size(y, 1);
    eta = 0.1;
    m = 1;
    u = X(F,:)'* w(F);
    grad_w = (eta/m)*X(F,:)*(1/n)*(u-y);
    w(F) = w(F) - grad_w;
    w(Fn) = -eta*X(Fn,:)*(1/n)*(u-y);
    F = union(F, Fn);
    if size(F,1) > mf
        for i = 1:batch_num
            [min_val, w_idx] = min(abs(w(F)));
            min_idx = F(w_idx);
            w(min_idx) = 0;
            F = F(F~=min_idx);
        end
    end
end
