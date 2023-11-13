extends MeshInstance3D

func _ready():
	var rng = RandomNumberGenerator.new()
	var colors := []	
	var colorOptions = [Color.BLUE, Color.WEB_GREEN, Color.MEDIUM_PURPLE, Color.YELLOW, Color.RED]
	var pickedColor = colorOptions[rng.randi_range(0, (colorOptions.size() - 1))]
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	#               010           110                         Y
#   Vertices     A0 ---------- B1            Faces      Top    -Z
#           011 /  |      111 /  |                        |   North
#             E4 ---------- F5   |                        | /
#             |    |        |    |          -X West ----- 0 ----- East X
#             |   D3 -------|-- C2                      / |
#             |  /  000     |  / 100               South  |
#             H7 ---------- G6                      Z    Bottom
#              001           101                          -Y
	
	var buildingHeight = rng.randi_range(0, 3)
	
	var a := Vector3(0, (.5 + buildingHeight), 0) 
	var b := Vector3(1, (.5 + buildingHeight), 0) 
	var c := Vector3(1, 0, 0) 
	var d := Vector3(0, 0, 0)
	var e := Vector3(0, (.5 + buildingHeight), 1)
	var f := Vector3(1, (.5 + buildingHeight), 1)
	var g := Vector3(1, 0, 1)
	var h := Vector3(0, 0, 1)
	var i := Vector3(.5, (1 + buildingHeight), 1)
	var j := Vector3(.5, (1 + buildingHeight), 0)

	var vertices := [   # faces (triangles)
	b,a,d,  b,d,c,  # N
	e,f,g,  e,g,h,  # S
	a,e,h,  a,h,d,  # W
	f,b,c,  f,c,g,  # E
	h,g,c,  h,c,d,  # B
	i,f,e,  a,b,j,  #TNS
	j,f,i,  f,j,b,  #TE
	a,i,e,  j,i,a   #TW
	]
	
	# Create normals
	for v in vertices:
		normals.append(v.normalized())
	
	for x in range(vertices.size()):
		colors.append(pickedColor)
		
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = PackedColorArray(colors)


	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	
	print_debug(mesh)
