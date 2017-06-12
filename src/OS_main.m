%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 200;
k = 1;
fr = 0.2;
cr = 0.1;
bNoise = 1;
idx = 1;


n = 1000*k;
n_o = int16(cr*n);

if bNoise == 1
    noise_str = ''; 
else
    noise_str = 'nn_';
end
    
%data_file = strcat('./data/RL_data_nn_', num2str(n_o), '.mat');
%data_file = strcat('./data/', num2str(n_o), '.mat');
data_file = FindDataPath( p, k, fr, cr, bNoise, idx );
data = load(data_file);
Xtr = data.Xtr;
ytr = data.ytr;
w_truth = data.beta;

%% Test different data sets
tic;
[w, S] = OS(Xtr, ytr, p*fr);
toc;

fprintf('[%dK|p%d|%.2f] - |w-w*|: %f\n', k, p, cr, norm(w_truth-w));
