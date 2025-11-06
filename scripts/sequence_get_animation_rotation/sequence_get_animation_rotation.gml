function sequence_get_animation_rotation(_seq, _name, _t)
{
	// Make sure we are using the sequence struct
	if ( !is_struct(_seq) ) _seq = sequence_get(_seq);
	
    // Normalize time 0–1 to frame
    var frame = _t;
    if (_t <= 1) frame = _seq.length * _t;

    var root_tracks = _seq.tracks;
    var track = sequence_get_animation_track(root_tracks, _name);
    if (!is_struct(track)) return 0;

    // Find "rotation" sub-track
    var rot_track;
    for (var i = 0; i < array_length(track.tracks); i++)
    {
        if (track.tracks[i].name == "rotation")
        {
            rot_track = track.tracks[i];
            break;
        }
    }

    if (!is_struct(rot_track)) return 0;

    var keys = rot_track.keyframes;
    if (array_length(keys) == 0) return 0;

    if (array_length(keys) == 1)
        return keys[0].channels[0].value;

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

    var r0 = prev.channels[0].value;
    var r1 = next.channels[0].value;
    return clamp(lerp(r0, r1, p), -360, 360);
}
