function sequence_get_animation_position(_seq, _name, _t)
{
	// Make sure we are using the sequence struct
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
	
    // Normalize time 0–1 to frame
    var frame = _t;
    if (_t <= 1) frame = _seq.length * _t;

    var root_tracks = _seq.tracks;
    var result = [0, 0];
    var track = sequence_get_animation_track(root_tracks, _name);
    if (!is_struct(track)) return result;

    // Find "position" sub-track
    var pos_track;
    for (var i = 0; i < array_length(track.tracks); i++)
    {
        if (track.tracks[i].name == "position")
        {
            pos_track = track.tracks[i];
            break;
        }
    }

    if (!is_struct(pos_track)) return result;

    var keys = pos_track.keyframes;
    if (array_length(keys) == 0) return result;

    // If only one keyframe
    if (array_length(keys) == 1)
    {
        var ch0 = keys[0].channels[0].value;
        var ch1 = keys[0].channels[1].value;
        return [ch1, ch0];
    }

    // Find bracketing keyframes
    var prev = keys[0];
    var next = keys[0];
    for (var i = 0; i < array_length(keys); i++)
    {
        if (keys[i].frame <= frame) prev = keys[i];
        if (keys[i].frame >= frame) { next = keys[i]; break; }
    }

    var t0 = prev.frame;
    var t1 = next.frame;
    var p = (frame - t0) / max(0.00001, (t1 - t0));

    var x0 = prev.channels[0].value;
    var y0 = prev.channels[1].value;
    var x1 = next.channels[0].value;
    var y1 = next.channels[1].value;

    var _x = lerp(x0, x1, p);
    var _y = lerp(y0, y1, p);
    return [_y, _x];
}
