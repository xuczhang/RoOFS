function [ w, S ] = SingleHR( X, y)
%RLH Summary of this function goes here
%   Detailed explanation goes here
p = size(X, 1);
n = size(X, 2);
w = zeros(p, 1);
S = 1:n;
S = S';
%k = n-n_o;
res = zeros(n,1);
tau = n;
MAX_ITER = 100;
MIN_THRES = 1e-3;
for iter=1:MAX_ITER
    res_old = res;
    tau_old = tau;
    w = update_w(X, y, S);
    res = update_res(X, y, w);    

    %tau = HT_ParamSearch_2(res, tau_old);
    tau = HTSearch(res, tau_old, p);
    
    %outlier_k = HT_ParamSearch(res);
    %outlier_k = 1000;
    %fprintf('outlier_idx=%d\n', outlier_k);
    S = HT(res, tau);

    if(iter == MAX_ITER)
        fprintf('Max Iteration Reached!!!');
    end
    
    %%fprintf('res=%f\n', norm(res(S)-res_old(S)));
    s = size(S, 1);
    %fprintf('res=%f tau=%d res_diff=%f\n', norm(res(S))/s, tau, norm(res(S)-res_old(S))/s);
    if norm(res(S)-res_old(S))/s <= MIN_THRES
    %if norm(res(S))/n <= MIN_THRES
        %fprintf('Finished!!!');
        break;
    end
end
 
end

function res = update_res(X, y, w)    
    n = size(y, 1);
    res = zeros(n, 1);
    for i = 1:n
        X_i = X(:,i);
        y_i = y(i);
        res(i) = abs(y_i - X_i'*w);
    end
end

function w = update_w(X, y, S)    
    y_S = y(S);
    X_S = X(:,S);
    w = inv(X_S*X_S')*X_S*y_S;
    
    %w = lasso(X_S', y_S, 'Lambda', 0.005);
end


function S = HT(res, k)
    [m mi] = sort(res);    
    S = mi(1:k);
end

function tau = HTSearch(res, old_tau, p)
    [sort_r, sort_ri] = sort(res);    
    %plot(sort_r, 'o', 'MarkerSize',2, 'MarkerEdgeColor','blue');
    n = size(res, 1);
    
    for tau = old_tau:-1:3*p
    %for tau = n:-1:1
        tau_ratio = 0.5;
        constrained = constaint(tau, tau_ratio, sort_r);
        
        if constrained
            break;
        end
        
    end
    
    if tau == 1
        fprintf('Error: no index found!!!\n');
    end

    
end

function constrained = constaint(tau, tau_ratio, sort_r)
    n = size(sort_r, 1);
    r_n = sort_r(n);
    %magic_point = floor(tau_ratio*tau);
    magic_point = floor(tau - n/2);
    [tau_o, tau_o_res] = cal_mean_tau(magic_point, sort_r);
    res_k = sort_r(tau);
    %thres = (tau_mean_res+(tau-tau_mean)/(n-tau_mean)*(r_n-tau_mean_res));
    
    % method1: r_tau <= delta^1/2 * tau/tau' * r_tau', where delta is a
    % parameter to adjust the r_tau threshold
    %thres = sqrt(thres_ratio*tau*tau_mean_res/tau_mean);
    thres = 2*tau*tau_o_res/tau_o;
    %thres_2 = (r_n + tau_o_res)/2;
    
    thres_new = (tau/(tau-n/2))*tau*tau_o_res/tau_o;

    %thres = min(thres_1, thres_2);
    
    constrained = 0;
    if res_k <= thres
        constrained = 1;
    end
   
end

% return the mean tau number for 
function [tau_mean, tau_res] = cal_mean_tau(thres_k, sort_r)
    tau_res = sqrt(norm(sort_r(1:thres_k))^2/thres_k);
    [a, tau_mean] = min(abs(sort_r-tau_res));
    %thres = sqrt(p* norm(sort_r(1:k))^2);
end
