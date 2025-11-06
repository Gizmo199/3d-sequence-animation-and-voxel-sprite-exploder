varying vec3 v_normal;
varying vec4 v_color;

void main()
{
	vec4 color = v_color;
	vec3 light = vec3(1);
	color.rgb *= .5 + .5 * max(dot(light, v_normal), 0.0);
    gl_FragColor = color;
}
