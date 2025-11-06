function sequence_get_animation_scale(_seq, _name, _t)
{
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
    var track = sequence_get_animation_track(_seq.tracks, _name);
    if (!is_struct(track)) return [1,1];

    var sub;
    for (var i = 0; i < array_length(track.tracks); i++)
        if (track.tracks[i].name == "scale") { sub = track.tracks[i]; break; }

    if (!is_struct(sub)) return [1,1];
    var keys = sub.keyframes;
    if (array_length(keys) == 0) return [1,1];
    if (array_length(keys) == 1)
        return [keys[0].channels[0].value, keys[0].channels[1].value];

    var frame = (_t <= 1)? _seq.length * _t : _t;
    var prev = keys[0], next = keys[array_length(keys)-1];
    for (var i = 0; i < array_length(keys); i++)
    {
        if (keys[i].frame <= frame) prev = keys[i];
        if (keys[i].frame >= frame) { next = keys[i]; break; }
    }

    var t0 = prev.frame, t1 = next.frame;
    var p = (frame - t0) / max(0.00001, (t1 - t0));
    return [
        lerp(prev.channels[0].value, next.channels[0].value, p),
        lerp(prev.channels[1].value, next.channels[1].value, p)
    ];
}
