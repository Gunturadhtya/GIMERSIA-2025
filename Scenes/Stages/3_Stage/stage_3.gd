class_name Stage1 extends Level

func _ready() -> void:
	super._ready()
	target_cleared_cube = 47

func get_screen_pos_for_cell(grid_pos: Vector2i) -> Vector2:
	return tilemap_layer.map_to_local(grid_pos) * TILE_OFFSET + Vector2(116, -34)

func get_cell_for_global_pos(global_pos: Vector2) -> Vector2i:
	var local_pos = tilemap_layer.to_local(global_pos)
	
	return tilemap_layer.local_to_map(local_pos)

func get_spawn_pos() -> Vector2i:
	return Vector2i(8,10)
