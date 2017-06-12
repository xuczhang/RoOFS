% p is the feature dimesnion
% k is the number of samples in K
% bNoise represents the dense noise or not

% generate the single data
k = 8;
p = 2000;
cr = 0.1;
fr = 0.2;
bNoise = 0;
DataSampling( p, k, fr, cr, bNoise, 1);

% generate the data per different corruption ratio
%{
p = 200; % feature dimension
k = 4;
bNoise = 1;
for cr = 0.05:0.05:0.4
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, idx);
    end
    
end
%}

% generate the data per different uncorrupted data size
%{
p = 100;
cr = 0.1;
bNoise = 1;
for k = 1:1:10
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, idx);
    end
end
%}
