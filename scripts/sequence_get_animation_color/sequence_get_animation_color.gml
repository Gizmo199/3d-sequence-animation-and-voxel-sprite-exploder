function sequence_get_animation_color(_seq, _name, _t)
{
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
    var track = sequence_get_animation_track(_seq.tracks, _name);
    if (!is_struct(track)) return c_white;

    var sub;
    for (var i = 0; i < array_length(track.tracks); i++)
        if (track.tracks[i].name == "color") { sub = track.tracks[i]; break; }

    if (!is_struct(sub)) return c_white;
    var keys = sub.keyframes;
    if (array_length(keys) == 0) return c_white;

    var frame = (_t <= 1)? _seq.length * _t : _t;
    var prev = keys[0], next = keys[array_length(keys)-1];
    for (var i = 0; i < array_length(keys); i++)
    {
        if (keys[i].frame <= frame) prev = keys[i];
        if (keys[i].frame >= frame) { next = keys[i]; break; }
    }

    var t0 = prev.frame, t1 = next.frame;
    var p = (frame - t0) / max(0.00001, (t1 - t0));
    var r = lerp(prev.channels[0].value, next.channels[0].value, p);
    var g = lerp(prev.channels[1].value, next.channels[1].value, p);
    var b = lerp(prev.channels[2].value, next.channels[2].value, p);
    var a = lerp(prev.channels[3].value, next.channels[3].value, p);
    return [make_color_rgb(r,g,b), a];
}
