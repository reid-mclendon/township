extends Camera3D

var minZ = 1
var maxZ = 1000
# Controls speed/level of zooming
var zoom_factor = 1.001
# Duration of zoom animation
var zoom_duration = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.transform.origin.z)
	set_process_input(true)
	

func _process(_delta):

	if Input.is_action_just_pressed("zoom_out"):
		translate_object_local(Vector3(0,0,1))
	if Input.is_action_just_pressed("zoom_in"):
		translate_object_local(Vector3(0,0,-1))

func _input(event):
	pass
	
