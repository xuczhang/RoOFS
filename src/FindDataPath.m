function [ data_file ] = FindDataPath( p, k, fr, cr, bNoise, idx )
%MAPDATAPATH Summary of this function goes here
%   Detailed explanation goes here
    
    %data_path = '~/Dataset/OnlineFeat/';
    data_path = 'D:/Dataset/OnlineFeat/';    
    
    str_noise = '';
    if ~bNoise
        str_noise = 'nn_';
    end
    data_file = strcat(data_path, num2str(k), 'K_', 'p', num2str(p), '_', str_noise, 'fr', num2str(int16(fr*100)), '_', 'cr', num2str(int16(cr*100)), '_', num2str(idx), '.mat');
    
end

