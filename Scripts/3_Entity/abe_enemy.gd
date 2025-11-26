class_name Abe extends CharacterBody2D

@export var world: Node2D
@export var target_move_counter: int = 5

@export_group("TileMap Data: Enemy highlighter")
#@export var normal_tile_source_id: int = 6
#@export var normal_tile_atlas_coords: Vector2i = Vector2i(0, 0)
#@export var normal_tile_alt_id: int = 0 
@export var highlight_tile_source_id: int = 6
@export var highlight_tile_atlas_coords: Vector2i = Vector2i(0, 0)
@export var highlight_tile_alt_id: int = 1

var _last_highlight_original_source_id: int = -1
var _last_highlight_original_atlas: Vector2i = Vector2i.ZERO
var _last_highlight_original_alt_id: int = 0

var current_grid_pos: Vector2i
var spawn_grid_pos: Vector2i
@onready var sprite: Sprite2D = $Sprite2D
#@onready var move_highlighter: Sprite2D = $MoveHighlighter
var is_active: bool = false
var has_iframe: bool = true
var _last_highlighted_pos: Vector2i = Vector2i(-999, -999)

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

# Cleanup on Death ---
func _exit_tree() -> void:
	# If we have a highlighted tile when we die, reset it!
	if _last_highlighted_pos != Vector2i(-999, -999) and world and world.tilemap_layer:
		world.tilemap_layer.set_cell(
			_last_highlighted_pos,
			_last_highlight_original_source_id,
			_last_highlight_original_atlas,
			_last_highlight_original_alt_id
		)
