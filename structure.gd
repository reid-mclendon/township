extends MeshInstance3D

func _ready():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var a := Vector3(0, 1, 0) 
	var b := Vector3(1, 1, 0) 
	var c := Vector3(1, 0, 0) 
	var d := Vector3(0, 0, 0)
	var e := Vector3(0, 1, 1)
	var f := Vector3(1, 1, 1)
	var g := Vector3(1, 0, 1)
	var h := Vector3(0, 0, 1)

	var vertices := [   # faces (triangles)
	b,a,d,  b,d,c,  # N
	e,f,g,  e,g,h,  # S
	a,e,h,  a,h,d,  # W
	f,b,c,  f,c,g,  # E
	a,b,f,  a,f,e,  # T
	h,g,c,  h,c,d,  # B
]
	
	# Create normals
	for v in vertices:
		normals.append(v.normalized())
		
	var colors := []
	var rng = RandomNumberGenerator.new()	
	var colorOptions = [Color.BLUE, Color.WEB_GREEN, Color.MEDIUM_PURPLE, Color.YELLOW]
	var pickedColor = colorOptions[rng.randi_range(0, colorOptions.size() - 1)]
	
	for i in range(vertices.size()):
		colors.append(pickedColor)
		
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = PackedColorArray(colors)


	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	print_debug(mesh)
