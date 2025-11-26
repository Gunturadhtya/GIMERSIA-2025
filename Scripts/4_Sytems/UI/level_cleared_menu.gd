extends CanvasLayer

@onready var retry_button = $VBoxContainer2/VBoxContainer/RetryButton
@onready var next_button = $VBoxContainer2/VBoxContainer/NextButton
@onready var menu_button = $VBoxContainer2/VBoxContainer/MenuButton

@onready var star_1 = $VBoxContainer2/HBoxContainer/Star1
@onready var star_2 = $VBoxContainer2/HBoxContainer/Star2
@onready var star_3 = $VBoxContainer2/HBoxContainer/Star3

@onready var turn_label = $VBoxContainer2/TurnLabel
var _current_thresholds: Dictionary = {}

func _ready() -> void:
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)
	
	# Set the star to dark color (for placeholder sprite)
	_reset_stars()

func _reset_stars():
	var dark_color = Color(0.2, 0.2, 0.2)
	if star_1: star_1.modulate = dark_color
	if star_2: star_2.modulate = dark_color
	if star_3: star_3.modulate = dark_color

# Method for setting up Star
func setup_grade(thresholds: Dictionary, final_value: int):
	turn_label.set_text("Turn: %d"%[GameStates.game_turn])
	GameStates.reset_game_stats()
	_current_thresholds = thresholds
	_calculate_and_animate_stars(final_value)

# Star Calculation
func _calculate_and_animate_stars(value: int):
	var stars_earned = 0
	
	# Check thresholds
	if value <= _current_thresholds.get(3, 0):
		stars_earned = 3
	elif value <= _current_thresholds.get(2, 0):
		stars_earned = 2
	else:
		stars_earned = 1
	
	# Star Animation (for placeholder star)
	var pop_tween = create_tween()
	# Star 1
	if stars_earned >= 1:
		
		pop_tween.tween_callback(func(): 
			AudioAutoloader.playStar1()
			star_1.modulate = Color.WHITE
			_pop_scale(star_1)
		)
		pop_tween.tween_interval(0.4) 
	# Star 2
	if stars_earned >= 2:
		
		pop_tween.tween_callback(func(): 
			AudioAutoloader.playStar2()
			star_2.modulate = Color.WHITE
			_pop_scale(star_2)
		)
		pop_tween.tween_interval(0.4)
	# Star 3
	if stars_earned >= 3:
		
		pop_tween.tween_callback(func(): 
			AudioAutoloader.playStar3()
			star_3.modulate = Color.WHITE
			_pop_scale(star_3)
		)

# Method for Simple "Pop" effect
func _pop_scale(node: Control):
	var tween = create_tween()
	node.scale = Vector2(0.1, 0.1)
	tween.tween_property(node, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.1)

func _on_retry_pressed():
	AudioAutoloader.playClick()
	get_tree().reload_current_scene()

func _on_next_pressed():
	AudioAutoloader.playClick()
	GameStates.load_next_level()

func _on_menu_pressed():
	AudioAutoloader.playClick()
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)
