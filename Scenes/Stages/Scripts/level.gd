class_name Level extends Node2D

@export var tilemap_layer: TileMapLayer
@export var player: Player
@export var level_cleared_menu: CanvasLayer
@export var game_over_menu: CanvasLayer
@export var rythim_manager: Control
var current_cleared_cube = 0
var target_cleared_cube = 15

const TILE_OFFSET = Vector2(0.2, 0.2)

func _ready() -> void:
	GameStates.reset_game_stats()
	get_tree().paused = false
	level_cleared_menu.retry_button.connect("pressed", _on_level_cleared_retry_pressed)
	game_over_menu.retry_button.connect("pressed", _on_game_over_retry_pressed)
	print(get_screen_pos_for_cell(get_spawn_pos()))
	
func get_screen_pos_for_cell(grid_pos: Vector2i) -> Vector2:
	return tilemap_layer.map_to_local(grid_pos) * TILE_OFFSET

func get_cell_for_global_pos(global_pos: Vector2) -> Vector2i:
	var local_pos = tilemap_layer.to_local(global_pos)
	
	return tilemap_layer.local_to_map(local_pos)

func get_spawn_pos() -> Vector2i:
	return Vector2i(5, 6)

func on_player_landed(grid_pos: Vector2i):
	GameStates.add_score()
	var tile_data = tilemap_layer.get_cell_tile_data(grid_pos)
	var current_index = tile_data.get_custom_data("color_index")
	var target_index = tile_data.get_custom_data("target_index")
	
	current_index += 1
	print("Current Cleared Cube Is : ", current_cleared_cube)
	var source_id = tilemap_layer.get_cell_source_id(grid_pos)
	
	if current_index > target_index:
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,1))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,1))
		await get_tree().create_timer(0.1).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(3,1))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,1))
		return
	
	if current_index == target_index:
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(1,0))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(2,0))
		await get_tree().create_timer(0.1).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(3,0))
		await get_tree().create_timer(0.05).timeout
		tilemap_layer.set_cell(grid_pos, source_id, Vector2i(0,1))
		current_cleared_cube += 1

func _on_level_cleared_retry_pressed():
	get_tree().reload_current_scene()

func _on_game_over_retry_pressed():
	get_tree().reload_current_scene()

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	$PausedMenu/PauseButton.visible = false
	$PausedMenu/CanvasLayer.visible = true


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	$PausedMenu/PauseButton.visible = true
	$PausedMenu/CanvasLayer.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit(0)

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/menu/main_menu.tscn")
