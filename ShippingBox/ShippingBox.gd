extends Area2D

onready var _Game = get_parent()

func _on_Timer_timeout():
	for child in get_children():
		if child.name.find("Crop") > -1:
			if !$ShippingBoxAnimation.is_playing() || $ShippingBoxAnimation.current_animation != "money":
				$ShippingBoxAnimation.play("money")
			child.queue_free()
			var money_gain = floor(child._water_consumed * 1000.0 * get_process_delta_time())
			money_gain = clamp(money_gain, 0, _Game.MAX_MONEY_GAIN)
			get_tree().root.get_node("Game").money += money_gain
