function sequence_get_animation_matrix(_seq, _name, _t, _offset=0)
{
    // Get 2D animation data
    var pos   = sequence_get_animation_position(_seq, _name, _t);
    var rot   = sequence_get_animation_rotation(_seq, _name, _t);
    var scale = sequence_get_animation_scale(_seq, _name, _t);

    // Build matrix
    var mat = matrix_build(pos[0], pos[1], _offset, 0, 0, rot, scale[0], scale[1], 1);
    return mat;
}
