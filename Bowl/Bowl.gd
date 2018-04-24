extends Area2D

onready var _Game = get_parent()

func _on_Timer_timeout():
	for child in get_children():
		if child.name.find("Crop") > -1:
			if !$BowlAnimation.is_playing() || $BowlAnimation.current_animation != "eat":
					$BowlAnimation.play("eat")
			child.queue_free()
			var energy_gain = child._water_consumed * 5000.0 * get_process_delta_time()
			get_tree().root.get_node("Game").stomach += energy_gain
			get_tree().root.get_node("Game").stomach = clamp(get_tree().root.get_node("Game").stomach, 0, _Game._STOMACH_CAPACITY)
