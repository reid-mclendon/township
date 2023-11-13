extends Node3D


# C
var packed_scene = [
preload("res://Scenes/Structure.tscn")		
]
var time = 0
var lastUpdateTime = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta	
	randomize()	
	if (time - lastUpdateTime >= randf_range(1, 3)):
		var x = randi() % packed_scene.size()
		var scene = packed_scene[x].instantiate()
		scene.transform.origin = Vector3(randf_range(-99,99), 0, randf_range(-99,99))
		scene.rotate(Vector3(0, 1, 0), randf_range(-6.28319, 6.28319))
		add_child(scene)
		lastUpdateTime = time
