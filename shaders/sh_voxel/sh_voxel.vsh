attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)

varying vec3 v_normal;
varying vec4 v_color;

void main()
{
    vec4 osp = vec4(in_Position, 1.0);
	vec4 osn = vec4(in_Normal, 0.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * osp;
    
	v_normal = normalize(vec3(gm_Matrices[MATRIX_WORLD] * osn));
    v_color = in_Colour;
}
