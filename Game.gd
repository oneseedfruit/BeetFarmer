extends Node2D

var has_game_started = false
var is_game_over = false

const WATER_COST = 10.0
const SEED_COST = 30.0
const GLOVE_ENERGY = 10.0

const MAX_MONEY_GAIN = 1000.0

const _STOMACH_CAPACITY = 1000.0
const _DUES_INCREMENT = 5.0

var max_ball = 3
var ball_count = 0
var seeds = 4

var stomach = 1000.0 setget _set_stomach,_get_stomach
var money = 500.0 setget _set_money
var dues = 5.0

func _set_stomach(value):
	if value < stomach - 10 :
		if $UI:
			if !$UI/UIAnimation.is_playing():
				$UI/UIAnimation.play("animate_stomach")
	if stomach <= 0:
		is_game_over = true
		$MainMenu.show_main_menu()
	if stomach < _STOMACH_CAPACITY || value < stomach:
		stomach = value
	
func _get_stomach():
	return stomach
	
func _set_money(value):
	if value < money:
		animate_money_UI()
	money = value

func animate_money_UI():
	if $UI:
		if !$UI/UIAnimation.is_playing():
			$UI/UIAnimation.play("animate_money")

func _ready():	
	get_tree().paused = true
	$UI/StomachBar.max_value = _STOMACH_CAPACITY
	$UI/MoneyDisplay.text = "$" + str(money)

func _process(delta):
	$UI/StomachBar.value = stomach
	$UI/MoneyDisplay.text = "$" + str(money)
	$UI/DuesDisplay.text = "$" + str(dues)
	$UI/CountdownDisplay.text = "IN " + str(floor($Timer.time_left)) + " PAY: "
	
	if Input.is_action_just_pressed("ui_cancel") || is_game_over:
		$MainMenu.show_main_menu()
	
func _on_Timer_timeout():
	self.money -= dues
	dues += _DUES_INCREMENT