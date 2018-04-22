extends Area2D

export (int, "Seed", "Sprout", "Sapling", "Plant", "Veggie") var growth_stage = 0 setget _set_growth_stage,_get_growth_stage
export (float) var water_consumption_rate = 1.5 

var till

var _water_consumed = 10.0
var _water_needed_to_grow = 10.0
var _last_water_consumed = 0.0

func _set_growth_stage(value):	
	if $Sprite && value < 5:
		$Sprite.frame = value
	growth_stage = value
	
func _get_growth_stage():
	return growth_stage	

func _process(delta):
	if till:
		if till.wetness > 0:
			till.wetness -= water_consumption_rate * delta
			_water_consumed += water_consumption_rate * delta
			
		elif till.wetness <= 0:
			till.wetness -= water_consumption_rate * delta
			_water_consumed -= water_consumption_rate * delta
	
		if self.growth_stage < 4:
			if _water_consumed > _last_water_consumed + _water_needed_to_grow:
				_last_water_consumed = _water_consumed
				self.growth_stage += 1
		
		if _water_consumed < 0:
			$Sprite.modulate = Color(1, 0.5, 1, 1)
		else:
			$Sprite.modulate = Color(1, 1, 1, 1)

		if _water_consumed < -10:
			queue_free()
