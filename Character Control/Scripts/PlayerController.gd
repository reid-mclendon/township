extends CharacterBody3D

@onready var camera_3d = $CameraMount/Camera3D
@onready var camera_mount = $CameraMount

const SPEED = 40.0
const JUMP_VELOCITY = 4.5

var sens_horizontal = 0.1
var sens_vertical = 0.1
var camera_control = false

var min_zoom = 1
var max_zoom = 100
# Controls speed/level of zooming
var zoom_factor = 1
# Duration of zoom animation
var zoom_duration = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func _unhandled_input(event):
	if camera_control:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
			camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(25))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.a
	#if Input.is_action_just_pressed("RightClick") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("RightClick"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		camera_control = true
		
	
	if Input.is_action_just_released("RightClick"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		camera_control = false
	
	if Input.is_action_just_pressed("Menu"):
		print("menupressed")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
