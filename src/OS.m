function [ w, S ] = OS(X, y, s)
%OS Summary of this function goes here
%   Detailed explanation goes here
    X = X';
    n = size(X, 1);
    p = size(X, 2);
    w = zeros(p, 1);
    S = 1;
    S = S';
    eta = 0.1;
    m = 1;

    for i = 2:p
        XS = X(:,S);
        wS = w(S);
        u = X(:,S)* w(S);
        grad_w = (eta/m)*X(:,S)'*(1/n)*(u-y);
        w(S) = w(S) - grad_w;
        w(i) = -eta*X(:,i)'*(1/n)*(u-y);
        S = union(S, i);
        if size(S,2) > s
            %[min_val, min_idx] = min(abs(w(S)));
            [min_val, w_idx] = min(abs(w(S)));
            min_idx = S(w_idx);
            w(min_idx) = 0;
            S = S(S~=min_idx);
        end
    end

end

