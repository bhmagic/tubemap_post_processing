clear
close all

mat_file_after_converting ={
%     'HB329.mat';
%     'HB330.mat';
%     'HB438.mat';
%     'HB593.mat';
%     'HB594.mat';
%     'HB597.mat';
    'HB442.mat';
    'HB328.mat';
    };

tubemap_folder_list ={
%     'HB329/';
%     'HB330/';
%     'HB438/';
%     'HB593/';
%     'HB594/';
%     'HB597/';
    'HB442/';
    'HB328/';
    };

parfor ii =1:length(tubemap_folder_list)
% ii =1;
    making_volume_csv_v2(mat_file_after_converting{ii}, tubemap_folder_list{ii} );
    making_heatmap(mat_file_after_converting{ii}, tubemap_folder_list{ii} );
end




