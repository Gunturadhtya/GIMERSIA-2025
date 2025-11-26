class_name Stage extends Node2D

@export var _spawn_pos: Vector2 = Vector2.ZERO
@export var tilemap_layer: TileMapLayer
@export var player: Player
@export var level_cleared_menu: CanvasLayer
@export var game_over_menu: CanvasLayer
@export var rythim_manager: CanvasLayer
@export var conductor: Node
@export var beat_map: BeatMap
@export var target_cleared_cube: int = 15

@export_group("Star Threshold")
@export var star_1_threshold: int
@export var star_2_threshold: int
@export var star_3_threshold: int

var current_cleared_cube = 0
var highlight_locked_tiles: Dictionary = {}

const TILE_OFFSET = Vector2(1, 1)

func _ready() -> void:
	GameStates.reset_game_stats()
	get_tree().paused = false	
	#print(get_screen_pos_for_cell(get_spawn_pos()))
	conductor.load_map(beat_map)
	
func get_screen_pos_for_cell(grid_pos: Vector2i) -> Vector2:
	return tilemap_layer.map_to_local(grid_pos) * TILE_OFFSET

func get_cell_for_global_pos(global_pos: Vector2) -> Vector2i:
	var local_pos = tilemap_layer.to_local(global_pos)
	return tilemap_layer.local_to_map(local_pos)

func get_spawn_pos() -> Vector2i:
	return _spawn_pos

func on_player_landed(grid_pos: Vector2i):
	if highlight_locked_tiles.has(grid_pos):
		return
	var tile_data = tilemap_layer.get_cell_tile_data(grid_pos)
	if not tile_data:
		return

	var source_id = tilemap_layer.get_cell_source_id(grid_pos)
	var current_index = tile_data.get_custom_data("color_index")
	var target_index = tile_data.get_custom_data("target_index")
	
	match player.current_match:
		GameStates.Match.PERFECT:
			current_index += 2
		GameStates.Match.OK:
			current_index += 1
		GameStates.Match.MISS:
			if current_index == 2: # If Lit up
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,1))
				await get_tree().create_timer(0.05).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,1))
				await get_tree().create_timer(0.05).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,1))
				return
				
			elif current_index == 1: # If Half Lit Up
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
				await get_tree().create_timer(0.03).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,0))
				await get_tree().create_timer(0.03).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,0))
				await get_tree().create_timer(0.03).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
				return
				
			else: # If not lit up
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
				await get_tree().create_timer(0.05).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,0))
				await get_tree().create_timer(0.05).timeout
				tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,0))
				return
		
	
	#print("Current Cleared Cube Is : ", current_cleared_cube)
	
	## if OK and the Cube are not lit
	if current_index == 1:
		#GameStates.add_score()
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
		await get_tree().create_timer(0.03).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,0))
		await get_tree().create_timer(0.03).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,0))
		await get_tree().create_timer(0.03).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
		return
	
	## If OK and the Cube are half lit or PERFECT and the cube are not lit or PERFECT and the cube are half lit
	if current_index == 2 or (current_index == 3 and player.current_match == GameStates.Match.PERFECT):
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,0))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,1))
		current_cleared_cube += 1
		return
	
	# If the cube already lit up
	if current_index > target_index:
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,1))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,1))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,1))
		return

func is_tile_walkable(grid_pos: Vector2i) -> bool:
	if tilemap_layer.get_cell_source_id(grid_pos) != -1:
		return true
	return false

# Method to show player's Star
func show_grade():
	player.has_moved = false
	
	# Dict to store star threshold
	var star_thresholds = {
		3: star_1_threshold,
		2: star_2_threshold,
		1: star_3_threshold
	}
	
	# Launching the star calculation method 
	if level_cleared_menu.has_method("setup_grade"):
		level_cleared_menu.setup_grade(star_thresholds, GameStates.game_turn)
	
