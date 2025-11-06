function sequence_get_animation_track(_tracks, _name)
{
    for (var i = 0; i < array_length(_tracks); i++)
    {
        var tr = _tracks[i];
        if (tr.name == _name) return tr;
        if (array_length(tr.tracks) > 0)
        {
            var found = sequence_get_animation_track(tr.tracks, _name);
            if (is_struct(found)) return found;
        }
    }
    return undefined;
}