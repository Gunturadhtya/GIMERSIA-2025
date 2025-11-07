extends CharacterBody2D

# We need a reference to the World (Main.gd) to ask "is this hop valid?"
@export var world: Node2D

# Player state variables
var current_grid_pos: Vector2i
var is_hopping: bool = false
var is_dead: bool = false
var lives: int = 3

# This stores the next move if you press a key mid-hop
var input_buffer: Vector2i = Vector2i.ZERO

var hop_tween: Tween = Tween.new()
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	current_grid_pos = world.get_spawn_pos()
	global_position = world.get_screen_pos_for_cell(current_grid_pos)

func _input(event):
	var move_dir = Vector2i.ZERO
	
	if event.is_action_pressed("Up"):
		move_dir = Vector2i(-1, -1) # Check your TileMap grid for correct mapping
	elif event.is_action_pressed("Right"):
		move_dir = Vector2i(1, -1) # Check your TileMap grid for correct mapping
	elif event.is_action_pressed("Left"):
		move_dir = Vector2i(-1, 1)   # Check your TileMap grid for correct mapping
	elif event.is_action_pressed("Down"):
		move_dir = Vector2i(1, 1)   # Check your TileMap grid for correct mapping
	
	if move_dir != Vector2i.ZERO:
		input_buffer = move_dir


func _process(delta):
	if is_dead:
		return

	if not is_hopping and input_buffer != Vector2i.ZERO:
		var next_move = input_buffer
		input_buffer = Vector2i.ZERO
		
		var target_grid_pos = current_grid_pos + next_move
		
		_start_hop(target_grid_pos)


func _start_hop(target_grid_pos: Vector2i):
	is_hopping = true

	var target_screen_pos = world.get_screen_pos_for_cell(target_grid_pos)

	hop_tween = create_tween()
	hop_tween.set_parallel(true) 

	hop_tween.tween_property(self, "global_position", target_screen_pos, 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	var arc_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	arc_tween.tween_property(sprite, "scale:y", 1.5, 0.125) 
	arc_tween.tween_property(sprite, "scale:y", 1.0, 0.125)
	
	await hop_tween.finished
	
	_on_hop_finished(target_grid_pos)


func _on_hop_finished(landed_grid_pos: Vector2i):

	current_grid_pos = landed_grid_pos
	is_hopping = false
