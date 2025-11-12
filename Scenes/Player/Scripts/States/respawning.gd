extends PlayerState

var respawing_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if respawing_tween and respawing_tween.is_running():
		respawing_tween.kill()
	
	_on_respawning()

func _on_respawning():
	player.current_grid_pos = player.world.get_spawn_pos()
	player.global_position = player.world.get_screen_pos_for_cell(player.current_grid_pos)
	
	respawing_tween = player.create_tween()
	
	respawing_tween.set_loops(4)
	
	respawing_tween.tween_property(
		player.sprite, 
		"modulate:a", 
		0.2, 
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	respawing_tween.tween_property(
		player.sprite, 
		"modulate:a", 
		1.0, 
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await respawing_tween.finished
	TurnManager.player_spawn_finished.emit()
	finished.emit(IDLE)

func exit():
	player.sprite.modulate.a = 1.0
	
	if respawing_tween and respawing_tween.is_running():
		respawing_tween.kill()
