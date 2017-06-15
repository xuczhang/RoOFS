%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 400;
k = 4;
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
    
data_file = FindDataPath( p, k, fr, cr, bNoise, idx );
data = load(data_file);
Xtr = data.Xtr;
ytr = data.ytr;
w_truth = data.beta;

%% Test different data sets
tic;
%[w, F, S] = OnlineFeat_Batch(Xtr, ytr, p*fr, 20);
[w, F, S] = OnlineFeat2(Xtr, ytr, p*fr);
%[w, F, S] = OnlineFeat(Xtr, ytr, 80);
toc;
w_truth_norm = norm(w_truth);
w_norm = norm(w);

fprintf('[%dK|p%d|fr%.2g|cr%.2g] - |w-w*|: %f\n', k, p, fr,cr, norm(w_truth-w));
