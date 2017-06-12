function [ w, F, S ] = OnlineFeat(X, y, mf)
%OS Summary of this function goes here
%   Detailed explanation goes here
    p = size(X, 1);
    n = size(X, 2);
    w = zeros(p, 1);
    F = 1;
    F = F';
    
    for i = 2:p
        [w, F] = FeatSelect(X, y, w, mf, F, i);
        [w_f, S] = SingleHR(X(F,:), y);
        w(F) = w_f;
    end
    
%     [w_f, S] = SingleHR(X(F,:), y);
%     w(F) = w_f;
end

function [ w, F ] = FeatSelect(X, y, w, mf, F, i)
    XF = X(F,:);
    wF = w(F);
    n = size(y, 1);
    eta = 0.1;
    m = 1;
    u = X(F,:)'* w(F);
    grad_w = (eta/m)*X(F,:)*(1/n)*(u-y);
    w(F) = w(F) - grad_w;
    w(i) = -eta*X(i,:)*(1/n)*(u-y);
    F = union(F, i);
    if size(F,2) > mf
        [min_val, w_idx] = min(abs(w(F)));
        min_idx = F(w_idx);
        w(min_idx) = 0;
        F = F(F~=min_idx);
    end
end
