function render_sequence_animation_mesh(_sequence, _vbuffers, _names, _time, _matrix=undefined, _zoffsets=0){
	
	// Base matrix it undefined
	static __identity = matrix_build_identity();
	_matrix ??= __identity;
	
	// Array of meshes from a sequence? Make sure to multiply them and apply them
	if ( is_array(_names) )
	{
		if ( !is_array(_vbuffers) ) _vbuffers = array_create(array_length(_names), _vbuffers);
		if ( !is_array(_zoffsets) ) _zoffsets = array_create(array_length(_names), _zoffsets);
		var m = sequence_get_animation_matrix(_sequence, _names[0], _time, _zoffsets[0]);
		var i = 1; repeat(array_length(_names)-1)
		{
			m = matrix_multiply(sequence_get_animation_matrix(_sequence, _names[i], _time, _zoffsets[i]), m);
			matrix_set(matrix_world, matrix_multiply(m, _matrix));
			vertex_submit(_vbuffers[i], pr_trianglelist, -1);
			i++;
		}
		matrix_set(matrix_world, __identity);
		return;
	}
	
	// Regular old mesh rendering from a sequence track
	matrix_set(matrix_world, matrix_multiply(sequence_get_animation_matrix(_sequence, _names, _time, _zoffsets), _matrix));
	vertex_submit(_vbuffers, pr_trianglelist, -1);
	matrix_set(matrix_world, __identity);
	
}