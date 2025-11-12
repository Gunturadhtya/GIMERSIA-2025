class_name Tutorial1 extends Level

func _ready() -> void:
	super._ready()
	target_cleared_cube = 15

func get_screen_pos_for_cell(grid_pos: Vector2i) -> Vector2:
	return tilemap_layer.map_to_local(grid_pos) * TILE_OFFSET + Vector2(-2, 80)

func get_cell_for_global_pos(global_pos: Vector2) -> Vector2i:
	var local_pos = tilemap_layer.to_local(global_pos) + Vector2(-2, 80)
	return tilemap_layer.local_to_map(local_pos)
