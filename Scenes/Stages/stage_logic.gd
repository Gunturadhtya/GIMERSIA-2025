extends Node2D

@export var tilemap_layer: TileMapLayer

var TILE_OFFSET = Vector2(0, 24)

func get_screen_pos_for_cell(grid_pos: Vector2i) -> Vector2:
	return tilemap_layer.map_to_local(grid_pos) + TILE_OFFSET

func get_spawn_pos() -> Vector2i:
	return Vector2i(39, 20)
