shader_type spatial;

uniform isampler3D voxels;

varying vec3 xyz;

void vertex() {
	xyz = (vec3(0, 1, 0) + VERTEX * vec3(1, -1, 1)) * (vec3(textureSize(voxels, 0)) - NORMAL * vec3(1, -1, 1));
}

void fragment() {
	int color = texelFetch(voxels, ivec3(xyz), 0).x;

	if (color == 0)
		discard;

	ALBEDO = xyz / vec3(textureSize(voxels, 0));
}
