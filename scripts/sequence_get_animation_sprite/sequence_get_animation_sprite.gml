function sequence_get_animation_sprite(_seq, _name)
{
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
    var track = sequence_get_animation_track(_seq.tracks, _name);
    if (!is_struct(track)) return -1;

    var keys = track.keyframes;
    if (array_length(keys) == 0) return -1;

    // The spriteIndex value is consistent per track
    if (array_length(keys[0].channels) > 0 && variable_struct_exists(keys[0].channels[0], "spriteIndex"))
        return keys[0].channels[0].spriteIndex;

    return -1;
}
