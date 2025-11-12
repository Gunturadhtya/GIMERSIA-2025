extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.is_hopping = false
	player.current_grid_pos = data["target_grid_pos"]
	var overlapping_areas = player.hitbox.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("disc"):
			finished.emit(ON_DISC, {"disc":area.get_parent()})
			return
	
	print(player.current_grid_pos)
	if _is_valid_cell(player.current_grid_pos):
		if _is_on_enemy_tile(player.current_grid_pos):
			finished.emit(DEAD)
		else:
			player.world.on_player_landed(player.current_grid_pos)
			finished.emit(IDLE, {"next_move" : data["next_move"]})
	else:
		finished.emit(FALLING)

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return player.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

func _is_on_enemy_tile(grid_pos: Vector2i) -> bool:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.current_grid_pos == grid_pos and enemy.is_active:
			return true
	return false
