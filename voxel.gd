@tool
class_name VoxelModel
extends MeshInstance3D

@export var voxels: Texture3D:
	get:
		return (material_override as ShaderMaterial).get_shader_parameter("voxels")
	set(value):
		(material_override as ShaderMaterial).set_shader_parameter("voxels", value)
		_rebuildMesh()
		notify_property_list_changed()

func _rebuildMesh():
	var voxels := self.voxels
	if voxels == null:
		mesh = null
		return
	
	var size_x := voxels.get_width()
	var size_y := voxels.get_height()
	var size_z := voxels.get_depth()
	
	var quads_count := (size_x + size_y + size_z) * 2
	
	var vertices = PackedVector3Array()
	vertices.resize(quads_count * 4)
	
	var normals = PackedVector3Array()
	normals.resize(quads_count * 4)

	var indices = PackedInt32Array()
	indices.resize(quads_count * 6)

	# camera at positive XYZ looking towards negative XYZ

	for i in range(size_x):
		var o := i
		vertices[o * 4    ] = Vector3((size_x - i) / float(size_x), 0, 0)
		vertices[o * 4 + 1] = Vector3((size_x - i) / float(size_x), 0, 1)
		vertices[o * 4 + 2] = Vector3((size_x - i) / float(size_x), 1, 0)
		vertices[o * 4 + 3] = Vector3((size_x - i) / float(size_x), 1, 1)
		normals[o * 4    ] = Vector3.RIGHT
		normals[o * 4 + 1] = Vector3.RIGHT
		normals[o * 4 + 2] = Vector3.RIGHT
		normals[o * 4 + 3] = Vector3.RIGHT
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 1
		indices[o * 6 + 2] = o * 4 + 2
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 1
		indices[o * 6 + 5] = o * 4 + 3

	for i in range(size_y):
		var o := size_x + i
		vertices[o * 4    ] = Vector3(0, (size_y - i) / float(size_y), 0)
		vertices[o * 4 + 1] = Vector3(0, (size_y - i) / float(size_y), 1)
		vertices[o * 4 + 2] = Vector3(1, (size_y - i) / float(size_y), 0)
		vertices[o * 4 + 3] = Vector3(1, (size_y - i) / float(size_y), 1)
		normals[o * 4    ] = Vector3.UP
		normals[o * 4 + 1] = Vector3.UP
		normals[o * 4 + 2] = Vector3.UP
		normals[o * 4 + 3] = Vector3.UP
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 2
		indices[o * 6 + 2] = o * 4 + 1
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 3
		indices[o * 6 + 5] = o * 4 + 1

	for i in range(size_z):
		var o := size_x + size_y + i
		vertices[o * 4    ] = Vector3(0, 0, (size_z - i) / float(size_z))
		vertices[o * 4 + 1] = Vector3(0, 1, (size_z - i) / float(size_z))
		vertices[o * 4 + 2] = Vector3(1, 0, (size_z - i) / float(size_z))
		vertices[o * 4 + 3] = Vector3(1, 1, (size_z - i) / float(size_z))
		normals[o * 4    ] = Vector3.BACK
		normals[o * 4 + 1] = Vector3.BACK
		normals[o * 4 + 2] = Vector3.BACK
		normals[o * 4 + 3] = Vector3.BACK
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 1
		indices[o * 6 + 2] = o * 4 + 2
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 1
		indices[o * 6 + 5] = o * 4 + 3

	## camera at negative XYZ looking towards positive XYZ

	for i in range(size_x):
		var o := size_x + size_y + size_z + i
		vertices[o * 4    ] = Vector3(i / float(size_x), 0, 0)
		vertices[o * 4 + 1] = Vector3(i / float(size_x), 0, 1)
		vertices[o * 4 + 2] = Vector3(i / float(size_x), 1, 0)
		vertices[o * 4 + 3] = Vector3(i / float(size_x), 1, 1)
		normals[o * 4    ] = Vector3.LEFT
		normals[o * 4 + 1] = Vector3.LEFT
		normals[o * 4 + 2] = Vector3.LEFT
		normals[o * 4 + 3] = Vector3.LEFT
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 2
		indices[o * 6 + 2] = o * 4 + 1
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 3
		indices[o * 6 + 5] = o * 4 + 1

	for i in range(size_y):
		var o := 2 * size_x + size_y + size_z + i
		vertices[o * 4    ] = Vector3(0, i / float(size_y), 0)
		vertices[o * 4 + 1] = Vector3(0, i / float(size_y), 1)
		vertices[o * 4 + 2] = Vector3(1, i / float(size_y), 0)
		vertices[o * 4 + 3] = Vector3(1, i / float(size_y), 1)
		normals[o * 4    ] = Vector3.DOWN
		normals[o * 4 + 1] = Vector3.DOWN
		normals[o * 4 + 2] = Vector3.DOWN
		normals[o * 4 + 3] = Vector3.DOWN
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 1
		indices[o * 6 + 2] = o * 4 + 2
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 1
		indices[o * 6 + 5] = o * 4 + 3

	for i in range(size_z):
		var o := 2 * (size_x + size_y) + size_z + i
		vertices[o * 4    ] = Vector3(0, 0, i / float(size_z))
		vertices[o * 4 + 1] = Vector3(0, 1, i / float(size_z))
		vertices[o * 4 + 2] = Vector3(1, 0, i / float(size_z))
		vertices[o * 4 + 3] = Vector3(1, 1, i / float(size_z))
		normals[o * 4    ] = Vector3.FORWARD
		normals[o * 4 + 1] = Vector3.FORWARD
		normals[o * 4 + 2] = Vector3.FORWARD
		normals[o * 4 + 3] = Vector3.FORWARD
		indices[o * 6    ] = o * 4
		indices[o * 6 + 1] = o * 4 + 2
		indices[o * 6 + 2] = o * 4 + 1
		indices[o * 6 + 3] = o * 4 + 2
		indices[o * 6 + 4] = o * 4 + 3
		indices[o * 6 + 5] = o * 4 + 1

	var surface_array := []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	#var shadow_array := []
	#shadow_array.resize(Mesh.ARRAY_MAX)
	#shadow_array[Mesh.ARRAY_VERTEX] = vertices
	#shadow_array[Mesh.ARRAY_INDEX] = indices

	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	#mesh.shadow_mesh = ArrayMesh.new()
	#mesh.shadow_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, shadow_array)
	#mesh.shadow_mesh.surface_set_material(0, TODO)
