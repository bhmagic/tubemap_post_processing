from graph_tool.all import *
import sys
import numpy as np

# file_location = "/mnt/e/LabMembers/yt/HB438/20220824_tubemap_newilastik/graph_annotated.gt"
# out_mat_file = "testing.mat"

file_location = sys.argv[1]
out_mat_file = sys.argv[2]

print(file_location)
print(out_mat_file)


grr = graph_tool.load_graph(file_location)

g_edge_geometry_coordinates = grr.properties[('g','edge_geometry_coordinates')]
g_edge_geometry_coordinates = g_edge_geometry_coordinates[0]

g_edge_geometry_radii = grr.properties[('g','edge_geometry_radii')]
g_edge_geometry_radii = g_edge_geometry_radii[0]



# shape                                 (graph)   (type: python::object, val: (5639, 7382, 3915))
# edge_geometry_type                    (graph)   (type: python::object, val: graph)
# edge_geometry_coordinates             (graph)   (type: python::object, val: [[2987.         6776.           50.        ]  [2987.         6775.           51.        ]
# edge_geometry_radii                   (graph)   (type: python::object, val: [1.         1.         2.82842712 ... 2.44948974 1.         1.73205081])
# edge_geometry_artery_binary           (graph)   (type: python::object, val: [ True  True  True ...  True  True  True])
# edge_geometry_artery_raw              (graph)   (type: python::object, val: [ 3415.  3415.  3415. ... 10079.  7228.  6395.])
# edge_geometry_coordinates_atlas       (graph)   (type: python::object, val: [[213.34797753 487.12351152  -1.67075013]  [213.34801724 487.04986498  -1.58224364]  [213.28516133
# edge_geometry_radii_atlas             (graph)   (type: python::object, val: [0.07481582 0.07481582 0.21161109 ... 0.18326058 0.07481582 0.1295848 ])
# edge_geometry_annotation              (graph)   (type: python::object, val: [  0   0   0 ... 387 387 387])
# edge_geometry_distance_to_surface     (graph)   (type: python::object, val: [20. 20. 20. ... 20. 20. 20.])





get_vertices = grr.get_vertices()
get_edges = grr.get_edges()


e_artery_binary = grr.properties[('e','artery_binary')]
e_artery_binary = np.vstack(e_artery_binary)

# e_artery_raw = grr.properties[('e','artery_raw')]

e_cumulative_distance = grr.properties[('e','cumulative_distance')]
e_cumulative_distance = np.vstack(e_cumulative_distance)

e_distance_to_surface = grr.properties[('e','distance_to_surface')]
e_distance_to_surface = np.vstack(e_distance_to_surface)

e_edge_geometry_indices = grr.properties[('e','edge_geometry_indices')]
e_edge_geometry_indices = np.vstack(e_edge_geometry_indices)
e_edge_geometry_indices = np.vstack(e_edge_geometry_indices)

e_euclidean_distance = grr.properties[('e','euclidean_distance')]
e_euclidean_distance = np.vstack(e_euclidean_distance)

# e_length = grr.properties[('e','length')]

e_radii = grr.properties[('e','radii')]
e_radii = np.vstack(e_radii)

e_radii_atlas = grr.properties[('e','radii_atlas')]
e_radii_atlas = np.vstack(e_radii_atlas)


# artery_binary                         (edge)    (type: bool)
# artery_raw                            (edge)    (type: double)
# cumulative_distance                   (edge)    (type: vector<double>)
# distance_to_surface                   (edge)    (type: double)
# edge_geometry_indices                 (edge)    (type: vector<int64_t>)
# euclidean_distance                    (edge)    (type: vector<double>)
# length                                (edge)    (type: double)
# radii                                 (edge)    (type: double)
# radii_atlas                           (edge)    (type: double)


v_annotation = grr.properties[('v','annotation')]
v_annotation = np.vstack(v_annotation)


v_artery_binary = grr.properties[('v','artery_binary')]
v_artery_binary = np.vstack(v_artery_binary)

# v_artery_raw = grr.properties[('v','artery_raw')]

v_coordinates = grr.properties[('v','coordinates')]
v_coordinates = np.vstack(v_coordinates)

v_coordinates_atlas = grr.properties[('v','coordinates_atlas')]
v_coordinates_atlas = np.vstack(v_coordinates_atlas)

v_distance_to_surface = grr.properties[('v','distance_to_surface')]
v_distance_to_surface = np.vstack(v_distance_to_surface)

v_radii = grr.properties[('v','radii')]
v_radii = np.vstack(v_radii)

v_radii_atlas = grr.properties[('v','radii_atlas')]
v_radii_atlas = np.vstack(v_radii_atlas)

# annotation                            (vertex)  (type: int64_t)
# artery_binary                         (vertex)  (type: bool)
# artery_raw                            (vertex)  (type: double)
# coordinates                           (vertex)  (type: vector<double>)
# coordinates_atlas                     (vertex)  (type: vector<double>)
# distance_to_surface                   (vertex)  (type: double)
# radii                                 (vertex)  (type: double)
# radii_atlas                           (vertex)  (type: double)


g_shape = grr.properties[('g','shape')]
g_shape = g_shape[0]


from scipy.io import savemat

savemat(out_mat_file, {'get_vertices':get_vertices,
                             'g_edge_geometry_coordinates':g_edge_geometry_coordinates,
                             'g_edge_geometry_radii':g_edge_geometry_radii,
                             'get_edges':get_edges,
                              'e_artery_binary':e_artery_binary,
                              'e_cumulative_distance':e_cumulative_distance,
                              'e_distance_to_surface':e_distance_to_surface,
                              'e_edge_geometry_indices':e_edge_geometry_indices,
                              'e_euclidean_distance':e_euclidean_distance,
                              'e_radii':e_radii,
                              'e_radii_atlas':e_radii_atlas,
                              'v_annotation':v_annotation,
                              'v_artery_binary':v_artery_binary,
                              'v_coordinates':v_coordinates,
                              'v_coordinates_atlas':v_coordinates_atlas,
                              'v_distance_to_surface':v_distance_to_surface,
                              'v_radii':v_radii,
                              'v_radii_atlas':v_radii_atlas,
                              'g_shape':g_shape
                               })
