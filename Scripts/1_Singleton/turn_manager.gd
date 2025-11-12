extends Node

signal player_turn_taken(move_dir: Vector2i)
signal player_spawn_finished

# --- New Pause Logic ---

# 1. Link your PauseMenu.tscn file here in the Inspector
@export var pause_menu_scene: PackedScene

# 2. This variable will hold our menu instance
var pause_menu_instance: Control


func _ready():
	# 3. Create an instance of the pause menu and add it to the scene
	if pause_menu_scene:
		pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		# Connect to its "resume_pressed" signal
		pause_menu_instance.resume_pressed.connect(toggle_pause)
		# Start the game with the menu hidden
		pause_menu_instance.hide()
	else:
		push_error("TurnManager: PauseMenu.tscn has not been assigned!")

# 4. This function runs every frame, checking for global input
func _unhandled_input(event: InputEvent):
	# 5. If the "pause" action (Escape key) is pressed...
	if event.is_action_pressed("pause"):
		# ...run our toggle function
		toggle_pause()

# 6. This single function handles both pausing and unpausing
func toggle_pause():
	# Flip the game's paused state
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	# Show or hide the menu based on the new state
	if is_paused:
		pause_menu_instance.show()
	else:
		pause_menu_instance.hide()
