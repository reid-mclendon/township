extends MeshInstance3D

var time = 0
var lastUpdateTime = 0
var buildingHeight = 1
var rng = RandomNumberGenerator.new()
var colorOptions = [
	Color.LIGHT_CORAL,
	Color.INDIAN_RED,
	Color.FIREBRICK, 
	Color.RED,
	Color.DARK_RED		
	]
var pickedColor

func updateMesh():
	if (mesh.get_surface_count() > 0): # Delete old mesh surfaces if they exist
		mesh.clear_surfaces()
	var surface_array = []
	var colors := []	
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
	
	var a := Vector3(0, (-.5 + buildingHeight), 0) 
	var b := Vector3(1, (-.5 + buildingHeight), 0) 
	var c := Vector3(1, 0, 0) 
	var d := Vector3(0, 0, 0)
	var e := Vector3(0, (-.5 + buildingHeight), 1)
	var f := Vector3(1, (-.5 + buildingHeight), 1)
	var g := Vector3(1, 0, 1)
	var h := Vector3(0, 0, 1)
	var i := Vector3(.5, (buildingHeight), 1)
	var j := Vector3(.5, (buildingHeight), 0)

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
	pickedColor = colorOptions[buildingHeight - 1]
	
	# Create normals
	for v in vertices:
		normals.append(v.normalized())
			
	for x in range(vertices.size()):
		colors.append(pickedColor)
		
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = PackedColorArray(colors)
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.resource_local_to_scene = true
	var newMaterial = StandardMaterial3D.new()
	newMaterial.vertex_color_use_as_albedo = true
	newMaterial.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	mesh.surface_set_material(0, newMaterial)
	lastUpdateTime = time
	if (buildingHeight < 5):
		buildingHeight += 1
		
func _ready():
	randomize()		
	updateMesh()
	add_child(CollisionPolygon3D.new())
	pass
	
func _physics_process(delta):
	time += delta
	if (time - lastUpdateTime >= randf_range(100, 1000)):
		updateMesh()


	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	
