extends CanvasLayer

onready var _Game = get_parent()
onready var original_modulate = _Game.get_node("Modulate").color
onready var MainMenuSound = _Game.get_node("MainMenuSound")

var _sound = [preload("res://Audio/sound1.wav"),
			preload("res://Audio/sound2.wav"),
			preload("res://Audio/sound3.wav"),
			preload("res://Audio/sound4.wav"),
			preload("res://Audio/sound5.wav"),
			preload("res://Audio/sound6.wav"),
			preload("res://Audio/sound7.wav")]

func _ready():
	if !_Game.has_game_started:
		$RestartButton.visible = false
	if !_Game.is_game_over:
		$GameOverLabel.visible = false
		$FinalScoreLabel.visible = false

func show_main_menu():
	get_tree().paused = true
	$TitleImage.visible = true
	$TitleLabel.visible = true
	$TitleLabel2.visible = true
	$InstructionLabel.visible = true
	$InstructionLabel2.visible = true
	$InstructionLabel3.visible = true
	$FruitImage.visible = true
	$FruitLabel.visible = true
	$FruitLabel2.visible = true
	$FruitLabel3.visible = true
	$RestartButton.visible = true
	$QuitButton.visible = true
	
	if !_Game.is_game_over:
		_Game.get_node("Modulate").color = original_modulate
		$StartButton.visible = true
#		_Game.get_node("UI/Modulate").color = Color(0, 0, 0, 1)
		if !_Game.has_game_started:
			$StartButton.text = "NEW GAME"
		elif _Game.has_game_started:
			$StartButton.text = "CONTINUE"
	else:
		_Game.get_node("Modulate").color = Color(0.4, 0.1, 0.1, 1)
		$GameOverLabel.visible = true
		$FinalScoreLabel.visible = true

func _on_StartButton_pressed():
	if !_Game.has_game_started:
		_Game.has_game_started = true
	_Game.get_node("Modulate").color = Color(1, 1, 1, 1)
	_Game.get_node("UI/Modulate").color = Color(1, 1, 1, 1)
	get_tree().paused = false
	$TitleImage.visible = false
	$TitleLabel.visible = false
	$TitleLabel2.visible = false
	$InstructionLabel.visible = false
	$InstructionLabel2.visible = false
	$InstructionLabel3.visible = false
	$FruitImage.visible = false
	$FruitLabel.visible = false
	$FruitLabel2.visible = false
	$FruitLabel3.visible = false
	$StartButton.visible = false
	$RestartButton.visible = false
	$QuitButton.visible = false
	$MainMenuSoundTimer.stop()
	
func _on_RestartButton_pressed():
	if _Game.has_game_started:
		get_tree().reload_current_scene()
		$MainMenuSoundTimer.stop()

func _on_QuitButton_pressed():
	get_tree().quit()

func _play_sound():		
	if !MainMenuSound.playing && rand_range(0, 1) > 0.3:
		MainMenuSound.stream = _sound[randi() % + 6]
		MainMenuSound.play()

func _on_MainMenuSoundTimer_timeout():
	_play_sound()
	