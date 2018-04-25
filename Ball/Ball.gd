extends KinematicBody2D

export (float) var speed_x = 300
export (float) var speed_y = 500
export (float) var bounce_factor = 2000
export (float) var gravity = 300
export (float) var friction = 1
export(int, "Water", "Glove", "Seed") var mode = 0 setget _set_mode,_get_mode
export (float) var wet_rate = 50.0
export (float) var max_planting_speed = 500

var _velocity = Vector2()
var _col_info
var _CropScene = preload("res://Crop/Crop.tscn")
var _crop1

var _sound = [preload("res://Audio/sound1.wav"),
			preload("res://Audio/sound2.wav"),
			preload("res://Audio/sound3.wav"),
			preload("res://Audio/sound4.wav"),
			preload("res://Audio/sound5.wav"),
			preload("res://Audio/sound6.wav"),
			preload("res://Audio/sound7.wav")]

func _set_mode(value):
	if $Sprite:
		if value == 0:
			$Sprite.frame = 9
		elif value == 1:
			$Sprite.frame = 8
		elif value == 2:
			$Sprite.frame = 8
			_crop1 = _CropScene.instance()
			$CropHolder/Pos2.add_child(_crop1)			
	mode = value
	
func _get_mode():
	return mode

func _physics_process(delta):
	_col_info = move_and_collide(_velocity * delta)
	
	# if there is a collision
	if _col_info:
		# if colliding with a paddle
		if _col_info.collider.name.find("Paddle") > -1:			
			_velocity.x = (position - _col_info.collider.position).normalized().x * speed_x

			_velocity.y = 0 # reset gravity when on paddle, prevents increased bounce speed_x
			_velocity.y += (position.y - _col_info.position.y) * bounce_factor * delta # ascend or descend based on collision
							
	if position.x <= 0: # if ball at left edge
		_velocity.x = abs(_velocity.x) # bounce ball to the right
		_velocity.x = clamp(_velocity.x, -speed_x * 0.5, speed_x * 0.5)	# half the ball's bounce back speed_x at edges
	elif position.x > get_viewport_rect().size.x: # if ball at right edge
		_velocity.x = -abs(_velocity.x) # bounce ball to the left
		_velocity.x = clamp(_velocity.x, -speed_x * 0.5, speed_x * 0.5)	# half the ball's bounce back speed_x at edges
	
	if position.y <= 0:
		_velocity.y = -_velocity.y
			
	_velocity.y += gravity * delta
	_velocity.x = clamp(_velocity.x, -speed_x, speed_x)
	_velocity.y = clamp(_velocity.y, -speed_y, speed_y)
	
	if _velocity.x > 0:
		_velocity.x -= friction * delta
	if _velocity.x < 0:
		_velocity.x += friction * delta
	if _velocity.y > 0:
		_velocity.y -= friction * delta
	if _velocity.y < 0:
		_velocity.y += friction * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if position.y > get_viewport_rect().size.y || position.x < 10 || position.x > get_viewport_rect().size.x + 10:
		if get_parent().ball_count > 0:
			get_parent().ball_count -= 1
		queue_free()

func _on_BallArea_area_entered(area):
	_play_sound()
	
	if area.name.find("Till") > -1:
		if mode == 0:
			area.get_parent().modulate = Color(0.5, 0.5, 1.0, 1)
			area.get_parent().start_watering(wet_rate)
		if mode == 2:
			var till = area
			if abs(_velocity.x) < max_planting_speed && abs(_velocity.y) < max_planting_speed:
				if _crop1 && !till.has_node("Crop"):
					$CropHolder/Pos2.remove_child(_crop1)
					_crop1.position = till.position - Vector2(0, 10)			
					_crop1.till = till.get_parent()
					till.add_child(_crop1)		
					_crop1.till = till.get_parent()
					_crop1 = null
					self.mode = 1
	
	if area.name.find("Crop") > -1:		
		if mode == 1 && area.growth_stage >= 4:			
			if _crop1 == null:
				_crop1 = _CropScene.instance()
				_crop1._water_consumed = area._water_consumed
				_crop1.growth_stage = area.growth_stage
				$CropHolder/Pos2.add_child(_crop1)
				_crop1.show_behind_parent = true
				_crop1.position += Vector2(0, 10)
				area.get_parent().remove_child(area)			
				
	if area.name.find("ShippingBox") > -1 || area.name.find("Bowl") > -1:
		print("Shipping!")
		if mode == 1 && _crop1 != null:			
			$CropHolder/Pos2.remove_child(_crop1)
			area.add_child(_crop1)
			_crop1.show_behind_parent = true
			_crop1.position -= Vector2(0, 20)
			_crop1.monitoring = false
			_crop1.monitorable = false
			_crop1 = null
				
func _on_BallArea_area_exited(area):
	if mode == 0 && area.name.find("Till") > -1:
		area.get_parent().modulate = Color(1, 1, 1, 1)
		area.get_parent().stop_watering()		
		
func _play_sound():
	if !$BallSound.playing && rand_range(0, 1) > 0.5:
		$BallSound.stream = _sound[randi() % + 6]
		$BallSound.play()
	
