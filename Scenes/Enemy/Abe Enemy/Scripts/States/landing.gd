extends AbeState

func enter(previous_state_path: String, data := {}) -> void:
	abe.current_grid_pos = data["target_grid_pos"]
	print("abe",abe.current_grid_pos)
	if _is_valid_cell(abe.current_grid_pos):
		if _is_on_player_tile(abe.current_grid_pos):
			var player_node = abe.get_meta("player_node")
			player_node.emit_signal("hit_by_enemy")
		finished.emit(IDLE)
	else:
		finished.emit(FALLING)

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return abe.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

func _is_on_player_tile(grid_pos: Vector2i) -> bool:
	var player_node = abe.get_meta("player_node")
	if player_node and player_node.current_grid_pos == grid_pos:
		return true
	return false
