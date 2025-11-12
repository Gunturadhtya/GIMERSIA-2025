extends CedeState

var hop_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if hop_tween and hop_tween.is_running():
		hop_tween.kill()
	
	if data.has("move_direction"):
		var next_move: Vector2i = data.get("move_direction")
		
		if next_move == Vector2i.ZERO:
			finished.emit(IDLE)
			return
			
		var target_grid_pos = cede.current_grid_pos + next_move
		
		_start_hop(target_grid_pos)
	
	else:
		finished.emit(IDLE)

func _start_hop(target_grid_pos: Vector2i):
	var target_screen_pos = cede.world.get_screen_pos_for_cell(target_grid_pos)
	
	hop_tween = cede.create_tween()
	hop_tween.set_parallel(true)
	hop_tween.tween_property(cede, "global_position", target_screen_pos, 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	var arc_tween = cede.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	arc_tween.tween_property(cede.sprite, "scale:y", DEFAULT_SCALE.y + DEFAULT_SCALE.y/2, 0.125)
	arc_tween.chain().tween_property(cede.sprite, "scale:y", DEFAULT_SCALE.y, 0.125)
	
	await hop_tween.finished
	var data: Dictionary = {"target_grid_pos": target_grid_pos}
	finished.emit(LANDING, data)
