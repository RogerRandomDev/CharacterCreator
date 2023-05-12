shader_type spatial;
render_mode skip_vertex_transform;

uniform sampler2D tex:filter_nearest;
uniform vec3 color:source_color;
void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float change_in_depth = 0.05;
	
	vec4 new_ndc = PROJECTION_MATRIX * vec4(0, 0, change_in_depth , 1.0);
	DEPTH = FRAGCOORD.z + new_ndc.z;
	vec4 col=texture(tex,UV);
	ALBEDO.rgb=col.rgb*color;
	ALPHA=col.a;
}