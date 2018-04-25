extends KinematicBody2D

const _STANDING_ENERGY = 5.0

export (float) var speed = 500
export(int, "Water", "Glove", "Seed") var launch_mode = 0 setget _set_mode,_get_mode

var _BallScene = preload("res://Ball/Ball.tscn")
var _velocity
var _dir = 0
var _y_pos
var _col_info

onready var _Game = get_parent()

func _set_mode(value):	
	if $Indicator:
		for spr in $Indicator.get_children():
			spr.visible = false
		if value == 0:
			$Indicator.frame = 9
		elif value == 1:
			$Indicator.frame = 8
		elif value == 2:
			$Indicator.frame = 8
			
			for spr in $Indicator.get_children():
				if _Game.seeds > 0:
					spr.visible = true		
		
	launch_mode = value
	
func _get_mode():
	return launch_mode

func _ready():
	_y_pos = position.y

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		_dir = -1
		$PlayerSprite.flip_h = true
	elif Input.is_action_pressed("right"):
		_dir = 1
		$PlayerSprite.flip_h = false
	elif Input.is_action_just_released("left") || Input.is_action_just_released("right"):
		_dir = 0
		
	_velocity = Vector2(speed * _dir, 0)
	position.x = clamp(position.x, 5, get_viewport_rect().size.x - 5)
	position.y = _y_pos
	
	if abs(_velocity.x) > 0:
		if !$PaddleAnimation.is_playing() || $PaddleAnimation.current_animation != "walk":
			$PaddleAnimation.play("walk")
	
	_col_info = move_and_collide(_velocity * delta)
	_Game.stomach -= 0.01 * abs(_velocity.x) * delta + _STANDING_ENERGY * delta

func _process(delta):			
	if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down"):		
		self.launch_mode += 1
		if _Game.seeds > 0:
			if self.launch_mode > 2:
				self.launch_mode = 0
		elif _Game.seeds <= 0:
			if self.launch_mode > 1:
				self.launch_mode = 0
	
	if _Game.ball_count < _Game.max_ball:
		if Input.is_action_just_pressed("launch"):
			if (launch_mode == 0 && _Game.money > _Game.WATER_COST) || (launch_mode >= 1 && _Game.stomach > _Game.GLOVE_ENERGY) || (launch_mode >= 2 && _Game.money > _Game.SEED_COST):
				if launch_mode == 2 && _Game.money > _Game.SEED_COST || launch_mode != 2:	
					var ball = _BallScene.instance()
					ball.position = position + Vector2(0, -20)
					if launch_mode == 0:
						_Game.money -= _Game.WATER_COST
					if launch_mode == 1:
						_Game.stomach -= _Game.GLOVE_ENERGY
					if launch_mode == 2:
						_Game.stomach -= _Game.GLOVE_ENERGY
	#					if _Game.seeds > 0:
	#						_Game.seeds -= 1
	#					else: 
	#						self.launch_mode = 1
	#						ball.mode = 1
						_Game.money -= _Game.SEED_COST
					ball.mode = launch_mode
					_Game.add_child(ball)
					_Game.ball_count += 1
				
				else:
					_Game.animate_money_UI()
			else:
				_Game.animate_money_UI()
				