function voxel_add_face(_vbuf, _x, _y, _z, _dir, _col, _invertZ=false, _matrix=undefined){
	
	// Base matrix
	static _identity = matrix_build_identity();
	_matrix ??= _identity;
	
	// Positions
	var vx = _x;
	var vy = _y;
	var vz = _z;
	var _t = matrix_transform_vertex(_matrix, vx, vy, vz);
	vx = _t[0];
	vy = _t[1];
	vz = _t[2];
	
	// Normals
	var nx = _dir[0];
	var ny = _dir[1];
	var nz = _dir[2];
	if ( _invertZ ) nz = -nz;
	var _t = matrix_transform_vertex(_matrix, nx, ny, nz);
	nx = _t[0];
	ny = _t[1];
	nz = _t[2];

	// Face corners
	var corners = [
		[0,0,0], [1,0,0],
		[1,1,0], [0,1,0]
	];

	// Orient corners
	for (var i = 0; i < 4; i++) {
		var c = corners[i];
		if (abs(nx) == 1) c = [0, c[0], c[1]];
		if (abs(ny) == 1) c = [c[0], 0, c[1]];
		if (abs(nz) == 1) c = [c[0], c[1], 0];
		corners[i] = c;
	}

	// Quad
	var tris = [0,1,2, 0,2,3];
	for (var t = 0; t < 6; t++) {
		var c = corners[tris[t]];
		var px = vx + c[0] + nx*(nx>0? 1 : 0);
		var py = vy + c[1] + ny*(ny>0? 1 : 0);
		var pz = vz + c[2] + nz*(nz>0? 1 : 0);
		vertex_position_3d(_vbuf, px, py, pz);
		vertex_normal(_vbuf, nx, ny, nz);
		vertex_color(_vbuf, _col, 1);
	}
	
}