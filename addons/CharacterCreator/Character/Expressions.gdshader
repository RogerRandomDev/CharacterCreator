shader_type spatial;
render_mode skip_vertex_transform;

uniform sampler2D tex:filter_nearest;
uniform vec3 color:source_color;

float delinearizeDepth(mat4 projMatrix,float depth,vec4 pos){
	float A = projMatrix[2].z;
    float B = projMatrix[3].z;
    return 0.5*(-A*depth + B) / depth + 0.5;
}

void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float change_in_depth = 0.05;
	
	DEPTH = FRAGCOORD.z-delinearizeDepth(PROJECTION_MATRIX,change_in_depth,FRAGCOORD);
	vec4 col=texture(tex,UV);
	ALBEDO.rgb=col.rgb*color;
	ALPHA=col.a;
}