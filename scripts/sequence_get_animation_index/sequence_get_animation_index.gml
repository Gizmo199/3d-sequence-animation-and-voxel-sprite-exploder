function sequence_get_animation_index(_seq, _name, _t)
{
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
    var track = sequence_get_animation_track(_seq.tracks, _name);
    if (!is_struct(track)) return 0;

    var keys = track.keyframes;
    if (array_length(keys) == 0) return 0;

    var frame = (_t <= 1)? _seq.length * _t : _t;

    // Find keyframe that spans the frame
    for (var i = 0; i < array_length(keys); i++)
    {
        var k = keys[i];
        if (frame >= k.frame && frame <= (k.frame + k.length))
        {
            if (array_length(k.channels) > 0 && variable_struct_exists(k.channels[0], "spriteIndex"))
                return k.channels[0].spriteIndex;
        }
    }
    return keys[0].channels[0].spriteIndex;
}
