extends MeshInstance3D

# state variables
var clicks = 0
var isDrawing
var originPos
var lines = []
var points = []

var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var surface_array = []
var current_array = []

func generate():
	var colors := []	
	# PackedVector**Arrays for mesh construction.
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
	h,g,c,  h,c,d,  # B
	]
	# Create normals
	for v in vertices:
		normals.append(v.normalized())
			
	for x in range(vertices.size()):
		colors.append(Color.CORAL)
		
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = PackedColorArray(colors)
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.resource_local_to_scene = true
	var newMaterial = StandardMaterial3D.new()
	newMaterial.vertex_color_use_as_albedo = true
	mesh.surface_set_material(0, newMaterial)
	
func isValid(pos):
	if pos == null:
		return false
	else:
		var vecPos = Vector3(pos)
		if abs(vecPos.x) > 100 || abs(vecPos.z) > 100:
			return false
		else: return true

func getMousePos():
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	var position2D = get_viewport().get_mouse_position()
	var position3D = dropPlane.intersects_ray(
							 get_viewport().get_camera_3d().project_ray_origin(position2D),
							 get_viewport().get_camera_3d().project_ray_normal(position2D))
	if isValid(position3D):
		return Vector3(position3D)
	else: return null
	
func addPoint(newPoint):
	points.push_back(newPoint)
	print('points: ', points)
	
func buildLines():
	print('buildingLines')
	lines.clear()	
	for p in points:
		var currentIdx = points.find(p)
		if currentIdx > 1:
			lines.push_back(points[currentIdx - 1])
		lines.push_back(p)
	print(lines)
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(lines)
	if (!isDrawing):
		isDrawing = true
	
func drawLines():
	if (mesh.get_surface_count() > 0):
		mesh.clear_surfaces()

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_array)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	surface_array.resize(Mesh.ARRAY_MAX)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Click once, second point is wherever mouse is
	if Input.is_action_just_released("LeftClick"):
		var newPoint = getMousePos()
		if newPoint != null:
			addPoint(newPoint)
			clicks += 1
		if clicks > 1:
			buildLines()
	
	if isDrawing:
		drawLines()
	
	pass
