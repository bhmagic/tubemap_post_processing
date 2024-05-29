function making_heatmap(mat_file_after_converting, dir_root_OG )

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


heat_map_length = accumarray([xxx, yyy, zzz ], g_length  ,crop_size_down_sample);
heat_map_radii = accumarray([xxx, yyy, zzz ], g_edge_geometry_radii.*1.8  ,crop_size_down_sample, @mean);

heat_map_length = heat_map_length./25./25./25;

heat_map_length = imgaussfilt3(heat_map_length,3.0);
heat_map_radii = imgaussfilt3(heat_map_radii,3.0);

niftiwrite(heat_map_length, [dir_root_OG, '/heat_map_l.nii']);
niftiwrite(heat_map_radii, [dir_root_OG, '/heat_map_r.nii']);




