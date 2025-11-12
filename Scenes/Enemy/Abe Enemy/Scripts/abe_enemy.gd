class_name Abe extends CharacterBody2D

@export var world: Node2D
@export var target_move_counter: int = 5
var current_grid_pos: Vector2i
var spawn_grid_pos: Vector2i
@onready var sprite: Sprite2D = $Sprite2D
@onready var move_highlighter: Sprite2D = $MoveHighlighter
var is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_grid_pos = world.get_cell_for_global_pos(self.position)
	spawn_grid_pos = current_grid_pos
	global_position = world.get_screen_pos_for_cell(current_grid_pos)
	
	var player_node = get_tree().get_root().find_child("Player", true, false)
	if player_node:
		set_meta("player_node", player_node)
	else:
		push_error("Enemy.gd: Could not find 'Player' node in scene!")
