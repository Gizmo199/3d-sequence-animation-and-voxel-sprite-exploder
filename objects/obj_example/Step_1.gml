// Camera look
locked ^= keyboard_check_pressed(vk_escape);
window_mouse_set_locked(locked);
if ( locked )
{
	yaw += window_mouse_get_delta_x() * sens;
	pitch -= window_mouse_get_delta_y() * sens;
	pitch = clamp(pitch, -89, 89);
}

// Camera zoom
distance += ( mouse_wheel_down() - mouse_wheel_up() ) * 8;

// Change meshes
if ( keyboard_check_pressed(vk_space) ) 
{
	if ( model == rounded ) model = minecraft;
	else model = rounded;
}