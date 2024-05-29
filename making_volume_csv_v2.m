function making_volume_csv_v2(mat_file_after_converting, dir_root_OG )

% mat_file_after_converting = "HB329.mat";
% dir_root_OG = 'HB329/';

csv_name = '16bit_allen_csv_20200916.csv';
label_file_name = append(dir_root_OG, '/tubemap/elastix_labels_to_resampled/result.tiff');


load(mat_file_after_converting);


info = imfinfo(label_file_name);
numberOfPages = length(info);
label_OG = {};
for k = 1 : numberOfPages
    label_OG{1,1,k} = imread(label_file_name, k);
end	
label_OG = cell2mat(label_OG);
label_OG = permute(label_OG,[2,1,3]);

crop_size_down_sample = size(label_OG);

g_edge_geometry_coordinates = double(g_edge_geometry_coordinates).* [1.8, 1.8, 2.0];


g_length = zeros(size(g_edge_geometry_radii));

g_length(2:end-1) = sqrt(sum((g_edge_geometry_coordinates(3:end,:)-g_edge_geometry_coordinates(1:end-2,:)) .* (g_edge_geometry_coordinates(3:end,:)-g_edge_geometry_coordinates(1:end-2,:)),2))./2;


e_edge_geometry_indices(:,1) = e_edge_geometry_indices(:,1)+1;
e_edge_geometry_indices = e_edge_geometry_indices();

falggg = true(size(g_edge_geometry_radii))';

falggg(e_edge_geometry_indices) = false;

g_edge_geometry_coordinates = g_edge_geometry_coordinates(falggg,:);
g_length = g_length(falggg)';
g_edge_geometry_radii = g_edge_geometry_radii(falggg)';

S_link.length = g_length;
S_link.radii = g_edge_geometry_radii.*1.8;


xxx = g_edge_geometry_coordinates(:,1);
yyy = g_edge_geometry_coordinates(:,2);
zzz = g_edge_geometry_coordinates(:,3);

xxx = ceil(xxx./25);
yyy = ceil(yyy./25);
zzz = ceil(zzz./25);



% 
% 
% e_location = ( g_edge_geometry_coordinates(e_edge_geometry_indices(:,1)+1,:) + g_edge_geometry_coordinates(e_edge_geometry_indices(:,2),:) )./2;
% 
% S_link.length = e_cumulative_distance;
% S_link.radii = e_cumulative_distance;
% S_link.length = e_cumulative_distance;
% 
% xxx = e_location(:,1);
% yyy = e_location(:,2);
% zzz = e_location(:,3);

% [xxx, yyy, zzz] = ind2sub(CropSize,S_skel(S_link.name));

% xxx = ceil(xxx.*1.8./25);
% yyy = ceil(yyy.*1.8./25);
% zzz = ceil(zzz.*2.0./25);







flag = xxx >0 & xxx <  crop_size_down_sample(1);
flag = flag & yyy >0 & yyy <  crop_size_down_sample(2);
flag = flag & zzz >0 & zzz <  crop_size_down_sample(3);

vox_ind = sub2ind(crop_size_down_sample,xxx(flag), yyy(flag), zzz(flag));
[vox_ind_uniq,~,ic] = unique(vox_ind);
net_down_sample_l = accumarray(ic,S_link.length(flag));

label = label_OG(vox_ind_uniq);


net_down_sample_r_l = accumarray(ic,S_link.radii(flag).*S_link.length(flag));
net_down_sample_r2_l = accumarray(ic,S_link.radii(flag).*S_link.radii(flag).*S_link.length(flag));
net_down_sample_r4_l = accumarray(ic,S_link.radii(flag).*S_link.radii(flag).*S_link.radii(flag).*S_link.radii(flag).*S_link.length(flag));






%csv_name = 'ARA2_annotation_structure_info.xlsx';
index_id = 1;
index_parent_id = 8;
index_name = 2;
index_acronym = 3;
index_structure_order = 7;

T = readtable(csv_name);

ROI_table.id = table2array(T(:,index_id));
ROI_table.parent = table2array(T(:,index_parent_id));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);
ROI_table.name = table2array(T(:,index_name));
ROI_table.acronym = table2array(T(:, index_acronym));
ROI_table.structure_order = table2array(T(:, index_structure_order));

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1, ROI_table.name);





for NNN = 1:length(ROI_table.idx)
    
    list_of_all_ROI_inside{NNN} = find(~isinf(distances(G,NNN)));
    
end



[logi,loca] = ismember(label,ROI_table.id);

net_down_sample_l = net_down_sample_l(logi);
net_down_sample_r_l = net_down_sample_r_l(logi);
net_down_sample_r2_l = net_down_sample_r2_l(logi);
net_down_sample_r4_l = net_down_sample_r4_l(logi);








loca = loca(logi);

net_down_sample_l= accumarray(loca,net_down_sample_l,size(ROI_table.id));
net_down_sample_r_l= accumarray(loca,net_down_sample_r_l,size(ROI_table.id));
net_down_sample_r2_l= accumarray(loca,net_down_sample_r2_l,size(ROI_table.id));
net_down_sample_r4_l= accumarray(loca,net_down_sample_r4_l,size(ROI_table.id));




[logi,loca] = ismember(label_OG,ROI_table.id);

loca = loca(logi);

total_volume= accumarray(loca,1,size(ROI_table.id));




for NNN = 1:length(ROI_table.idx)

    net_down_sample_l_fin(NNN) = sum(net_down_sample_l(list_of_all_ROI_inside{NNN}));
    net_down_sample_r_l_fin(NNN) = sum(net_down_sample_r_l(list_of_all_ROI_inside{NNN}));
    net_down_sample_r2_l_fin(NNN) = sum(net_down_sample_r2_l(list_of_all_ROI_inside{NNN}));
    net_down_sample_r4_l_fin(NNN) = sum(net_down_sample_r4_l(list_of_all_ROI_inside{NNN}));
    total_volume_fin(NNN) = sum(total_volume(list_of_all_ROI_inside{NNN}));

end


total_volume_fin = total_volume_fin.*25.*25.*25;

net_down_sample_l_v_fin = net_down_sample_l_fin./total_volume_fin;
net_down_sample_r_l_fin = net_down_sample_r_l_fin./net_down_sample_l_fin;
net_down_sample_r2_l_fin = net_down_sample_r2_l_fin./total_volume_fin;
net_down_sample_r4_l_fin = net_down_sample_r4_l_fin./total_volume_fin;






%net_down_sample_l_fin = net_down_sample_l_fin'./2./1000000;

%length_density = net_down_sample_l_fin./total_volume_fin;


finnal_table = cell2table([num2cell(ROI_table.id), ...
                        ROI_table.name, ...
                        ROI_table.acronym, ...
                        num2cell(ROI_table.structure_order ), ...
                        num2cell(total_volume_fin'.*1E-9), ...
                        num2cell(net_down_sample_l_fin'.*1E-6), ...
                        num2cell(net_down_sample_l_v_fin'.*1E3), ...                        
                        num2cell(net_down_sample_r_l_fin')]);
                        
%                         , ...
%                         num2cell(net_down_sample_r2_l_fin'), ...
%                         num2cell(net_down_sample_r4_l_fin')]);

finnal_table.Properties.VariableNames = {'ROI_id', ...
                                    'ROI_name', ...
                                    'ROI_accronym', ...
                                    'Structure_order', ...
                                    'net_volume', ...
                                    'net_l', ...
                                    'net_l_v', ...
                                    'rl_l_um'};
                                
%                                     ...
%                                     'r2l_l_um2', ...
%                                     'r4l_l_um4'};

% finnal_table = cell2table([num2cell(ROI_table.id), ROI_table.name, ROI_table.acronym, num2cell(ROI_table.structure_order ), num2cell(net_down_sample_r_l_fin'), num2cell(net_down_sample_r2_l_fin'), num2cell(net_down_sample_r4_l_fin')]);                    
% finnal_table.Properties.VariableNames = {'ROI_id', 'ROI_name', 'ROI_accronym', 'Structure_order', 'rl_l_um', 'r2l_l_um2', 'r4l_l_um4'};
                                
                                
finnal_table_file = [dir_root_OG, '/roi_analysis.csv'];
delete(finnal_table_file);
writetable(finnal_table, finnal_table_file, 'writevariablenames',1);






