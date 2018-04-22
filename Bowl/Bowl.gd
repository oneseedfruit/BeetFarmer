extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	for child in get_children():
		if child.name.find("Crop") > -1:
			if !$BowlAnimation.is_playing() || $BowlAnimation.current_animation != "eat":
					$BowlAnimation.play("eat")
			child.queue_free()
			get_tree().root.get_node("Game").stomach += child._water_consumed * 5000.0 * get_process_delta_time()
