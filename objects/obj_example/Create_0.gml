// Position
x = 0;
y = 0;
z = 0;

// Camera stuff
fov = 60;
aspect = 16/9;
near = 0.1;
far = 2048;
locked = false;
distance = 96;
sens = 0.1;
pitch = -30;
yaw = -45;
view = -1;
proj = -1;
view_enabled[0] = true;
view_visible[0] = true;

// 3D enable
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
layer_force_draw_depth(true, 1);

// Matrix for building the head rotated by 90 degrees (since its facing forward)
var _headOrientation = matrix_build(0, 0, 0, 90, 0, 0, 1, 1, 1);

// Explode sprites into voxel models with a rounded look
var _smoothingDepth = 8;
rounded = 
{
	head	: voxel_create_from_sprite(sp_head, 0, 5, _smoothingDepth, _headOrientation),
	torso	: voxel_create_from_sprite(sp_torso, 0, 8, _smoothingDepth),
	upper	: voxel_create_from_sprite(sp_upper, 0, 4, _smoothingDepth),
	arm		: voxel_create_from_sprite(sp_arm_lower, 0, 2, _smoothingDepth),
	leg		: voxel_create_from_sprite(sp_leg_lower, 0, 2, _smoothingDepth)
}

// Explode sprites into voxel models with a minecraft look
var _smoothingDepth = 0;
minecraft = 
{
	head	: voxel_create_from_sprite(sp_head, 0, 5, _smoothingDepth, _headOrientation),
	torso	: voxel_create_from_sprite(sp_torso, 0, 8, _smoothingDepth),
	upper	: voxel_create_from_sprite(sp_upper, 0, 4, _smoothingDepth),
	arm		: voxel_create_from_sprite(sp_arm_lower, 0, 2, _smoothingDepth),
	leg		: voxel_create_from_sprite(sp_leg_lower, 0, 2, _smoothingDepth)
}

// Set our model
model = minecraft;