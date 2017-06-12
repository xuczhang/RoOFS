function [] = DataSampling( p, k, fr, cr, bNoise, idx)

    %% Initialize the constant
    %p = 100; % feature dimension
    %k = 1;
    %cr = 0.1; % corruption ratio (from 0.1 to 1.2)
    %fr = 0.1; % feature sparsity ratio
    %bNoise = 1;

    n = 1000*k; % total sample number in training data
    n_o = int16(cr*n); % corruption sample number(from 100 to 1200)
    n_u = n - n_o;

    %% Generate the training sample data
    % sample w by unit norm vector in p dimension
    beta = [rand(p*fr, 1); zeros(p*(1-fr),1)];    
    beta_norm = norm(beta);
    beta = beta/beta_norm;

    % sample x by normal distribution with mu=0 and cov=I_p
    X_mu = zeros(p, 1);
    X_cov = eye(p);
    Xtr_a = mvnrnd(X_mu, X_cov, n_u)'; % authetic data
    Xtr_o = mvnrnd(X_mu, X_cov, n_o)'; % outlier part X
    Xtr = [Xtr_a, Xtr_o];  
    
    % sample noise eplison for outliers
    e_mu = zeros(n_u, 1);
    e_cov = eye(n_u) * 0.1;
    e_a = mvnrnd(e_mu, e_cov)';

    % generate the authentic samples by y_i = <w, x_i> + v_i
    if bNoise
        ytr_a = Xtr_a'*beta + e_a;
    else
        ytr_a = Xtr_a'*beta;
    end

    %% Generate Training Outlier Data
    % sample corruption vector b as b_i ~ U(-5|y*|_inf, 5|y*|_inf)
    u_range = 5*norm(ytr_a, inf);
    u = -u_range + 2*u_range*rand(n_o,1);

    % sample noise eplison for outliers
    e_mu = zeros(n_o, 1);
    e_cov = eye(n_o) * 0.01;
    if n_o == 0
        e_o = zeros(0,1);
    else
        e_o = mvnrnd(e_mu, e_cov)';
    end

    % generate outlier y: ytr_o = sign(<-beta, x_o>)
    if bNoise
        ytr_o = Xtr_o'*beta + u + e_o;
    else
        ytr_o = Xtr_o'*beta + u;
    end

    ytr = [ytr_a; ytr_o];

    %z = -ytr_all.*(Xtr_all'*w);
    %t = ytr_all - sigmf(Xtr_all'*w, [1 0]);

    %% Save the results into the output file
    str_noise = '';
    if ~bNoise
        str_noise = 'nn_';
    end
    
    data_file = FindDataPath( p, k, fr, cr, bNoise, idx );
    save(data_file, 'Xtr', 'ytr', 'beta');
end

