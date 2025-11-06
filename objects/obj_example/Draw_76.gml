// Get look at
var lx = x - dcos(yaw) * dcos(pitch) * distance;
var ly = y - dsin(yaw) * dcos(pitch) * distance;
var lz = z - dsin(pitch) * distance;

// Build camera matrices and apply them
view = matrix_build_lookat(lx, ly, lz, x, y, z, 0, 0, 1);
proj = matrix_build_projection_perspective_fov(-fov, -aspect, near, far);
camera_set_view_mat(view_camera[0], view);
camera_set_proj_mat(view_camera[0], proj);
