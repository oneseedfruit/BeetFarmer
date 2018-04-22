extends Sprite

export (float) var dry_rate = 5.0

const _MAX_WETNESS = 100.0
var wetness = 0.0 setget _set_wetness,_get_wetness

var _is_being_watered = false
var _watered_rate = 0.0

func _set_wetness(value):	
	if wetness >= 75.0:
		frame = 7
	elif wetness >= 30.0:
		frame = 6
	else:
		frame = 5
	wetness = value
	
func _get_wetness():
	return wetness

func _process(delta):
	if _is_being_watered:
		self.wetness += _watered_rate * delta
	
	if wetness < 0.0:
		self.wetness = 0.0
	elif wetness >= 0.0:
		self.wetness -= dry_rate * delta
		
func start_watering(dt):
	_watered_rate = dt
	_is_being_watered = true
	
func stop_watering():
	_watered_rate = 0.0
	_is_being_watered = false