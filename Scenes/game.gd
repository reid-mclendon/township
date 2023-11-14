extends Node3D


# C
var packed_scene = [
preload("res://Scenes/Structure.tscn")		
]
var time = 0
var lastUpdateTime = 0
var bounds
var origins = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta	
	bounds = time * (time / (5 * time))
	randomize()	
	if (time - lastUpdateTime >= randf_range(1, 3)):
		var x = randi() % packed_scene.size()
		var scene = packed_scene[x].instantiate()
		var potentialOrigin = Vector3(clamp(randf_range(-bounds,bounds), -99, 99), 0, clamp(randf_range(-bounds,bounds), -99, 99))
		for origin in origins:
			if (potentialOrigin.distance_to(origin) <= 3):
				lastUpdateTime = time				
				return
			else:	
				scene.transform.origin = potentialOrigin
		scene.rotate(Vector3(0, 1, 0), randf_range(-6.28319, 6.28319))
		add_child(scene)
		origins.push_back(scene.transform.origin)
		lastUpdateTime = time
