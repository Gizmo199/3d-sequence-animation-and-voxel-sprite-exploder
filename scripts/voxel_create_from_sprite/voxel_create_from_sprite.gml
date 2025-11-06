function voxel_create_from_sprite(_spr, _subimg, _depth, _smoothDepth=8, _matrix=undefined)
{
	// Draw surface (for get_pixel)
	static _surface = -1;
	
	// Voxel buffer format
	static _format = undefined;
	if ( _format == undefined )
	{
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		vertex_format_add_color();
		_format = vertex_format_end();
	}
	
	// Directions for faces
	static _dirs = [
        [ 1, 0, 0],
        [-1, 0, 0],
        [ 0, 1, 0],
        [ 0,-1, 0],
        [ 0, 0, 1],
        [ 0, 0,-1]
    ];
	
	// Get sprite data
	var w = sprite_get_width(_spr);
    var h = sprite_get_height(_spr);
	var _ox = sprite_get_xoffset(_spr);
	var _oy = sprite_get_yoffset(_spr);
	
	// Create voxel grid [_x][_y][_z]
    var voxels = array_create(w);
    for (var _x = 0; _x < w; _x++) {
        voxels[_x] = array_create(h);
        for (var _y = 0; _y < h; _y++) {
            voxels[_x][_y] = array_create(_depth, false);
        }
    }
	
	// Create surface, draw sprite to it
	if ( !surface_exists(_surface) ) _surface = surface_create(512, 512);
	surface_resize(_surface, w, h);
	surface_set_target(_surface);
	draw_clear_alpha(0, 0);
	draw_sprite(_spr, _subimg, _ox, _oy);
	surface_reset_target();
	
	// Build alpha map
	var alpha_map = array_create(w);
	for (var _x = 0; _x < w; _x++) {
	    alpha_map[_x] = array_create(h);
	    for (var _y = 0; _y < h; _y++) {
	        var col = surface_getpixel_ext(_surface, _x, _y);
	        var alp = (col >> 24) & 255;
	        alpha_map[_x][_y] = (alp > 10);
	    }
	}
	
	// Compute distance-to-edge map (cheap approximation) for smoothing
	var dist_map = array_create(w);
	for (var _x = 0; _x < w; _x++) {
	    dist_map[_x] = array_create(h, 0);
	    for (var _y = 0; _y < h; _y++) {
	        if (!alpha_map[_x][_y]) continue;
        
	        var nearest = 9999;
	        for (var ox = -_smoothDepth; ox <= _smoothDepth; ox++) {
	            for (var oy = -_smoothDepth; oy <= _smoothDepth; oy++) {
	                var xx = _x + ox;
	                var yy = _y + oy;
	                if (xx < 0 || yy < 0 || xx >= w || yy >= h) continue;
	                if (!alpha_map[xx][yy]) {
	                    var d = sqrt(ox*ox + oy*oy);
	                    if (d < nearest) nearest = d;
	                }
	            }
	        }
	        dist_map[_x][_y] = nearest;
	    }
	}

	// Normalize distance values
	var max_dist = 0;
	for (var _x = 0; _x < w; _x++){
		for (var _y = 0; _y < h; _y++){
		    if (dist_map[_x][_y] > max_dist) max_dist = dist_map[_x][_y];
		}
	}
	
	// Make sure max distance is not negative
	if (max_dist <= 0) max_dist = 1;
	
	// Fill voxels based on luminosity
	for (var _y = 0; _y < h; _y++) {
	    for (var _x = 0; _x < w; _x++) {
	        var col = surface_getpixel_ext(_surface, _x, _y);
	        var alp = (col >> 24) & 255;
	        if (alp > 0.1) {
				var edge_factor = clamp(dist_map[_x][_y] / max_dist, 0, 1);
				edge_factor = power(edge_factor, 0.8); // adjust falloff softness

				var local_depth = ceil(edge_factor * _depth);
				if (local_depth < 1) local_depth = 1;

	            // fill only up to that depth
	            for (var _z = 0; _z < local_depth; _z++) {
	                voxels[_x][_y][_z] = col;
	            }
	        }
	    }
	}
	
	// Draw backside if applicable (2nd frame)
	surface_set_target(_surface);
	draw_clear_alpha(0, 0);
	draw_sprite(_spr, _subimg+1, _ox, _oy);
	surface_reset_target();

    // Create vertex buffer
    var vbuf = vertex_create_buffer();
    vertex_begin(vbuf, _format);

    // Add visible faces only
    for (var _x = 0; _x < w; _x++){
	    for (var _y = 0; _y < h; _y++){
		    for (var _z = 0; _z < _depth; _z++) {
		        var col = voxels[_x][_y][_z];
		        if (!col) continue;
		        for (var f = 0; f < 6; f++) {
			
					// Check if we are a visible face
		            var nx = _x + _dirs[f][0];
		            var ny = _y + _dirs[f][1];
		            var nz = _z + _dirs[f][2];
		            var neighbor_exists = (
						nx >= 0 && ny >= 0 && nz >= 0 &&
						nx < w && ny < h && nz < _depth &&
		                voxels[nx][ny][nz]
					);
			
					// Generate faces?
		            if (!neighbor_exists) 
					{
		                voxel_add_face(vbuf, _x-_ox, _y-_oy, _z, _dirs[f], col, false, _matrix);
						if ( _z > 0 ) 
						{
							var _col = surface_getpixel(_surface, _x, _y);
							voxel_add_face(vbuf, _x-_ox, _y-_oy, -_z, _dirs[f], _col, true, _matrix);
						}
		            }
		        }
		    }
		}
	}
	
	// Finish and freeze
    vertex_end(vbuf);
	vertex_freeze(vbuf);

    // Return voxel buffer
    return vbuf;
}
