extends Node

signal player_turn_taken(move_dir: Vector2i)
signal player_spawn_finished


@export var pause_menu_scene: PackedScene

var pause_menu_instance: Control


func _ready():
	if pause_menu_scene:
		pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.resume_pressed.connect(toggle_pause)
		pause_menu_instance.hide()
	else:
		push_error("TurnManager: PauseMenu.tscn has not been assigned!")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	if is_paused:
		pause_menu_instance.show()
	else:
		pause_menu_instance.hide()
