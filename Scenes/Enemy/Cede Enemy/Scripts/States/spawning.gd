extends CedeState

var spawning_tween: Tween
var move_counter: int = 0
var has_player_spawned: bool = false

func enter(previous_state_path: String, data := {}) -> void:
	cede.is_active = false
	cede.current_grid_pos = cede.spawn_grid_pos
	cede.global_position = cede.world.get_screen_pos_for_cell(cede.current_grid_pos)
	move_counter = 0
	print("test")
	has_player_spawned = false
	cede.sprite.hide()
	
	TurnManager.player_turn_taken.connect(_on_player_turn)

func _on_player_turn(_move_dir: Vector2i):
	if has_player_spawned:
		return

	move_counter += 1
	print(move_counter)
	if move_counter >= cede.target_move_counter:
		TurnManager.player_turn_taken.disconnect(_on_player_turn)
		_start_spawn_animation()

func _start_spawn_animation():
	cede.sprite.show()
	
	spawning_tween = cede.create_tween()
	spawning_tween.set_loops(4)
	spawning_tween.set_parallel(false)

	spawning_tween.tween_property(
		cede.sprite, "modulate:a", 0.2, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	spawning_tween.tween_property(
		cede.sprite, "modulate:a", 1.0, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await spawning_tween.finished
	cede.is_active = true
	finished.emit(IDLE)

func exit():
	
	if TurnManager.player_turn_taken.is_connected(_on_player_turn):
		TurnManager.player_turn_taken.disconnect(_on_player_turn)
	
	cede.sprite.modulate.a = 1.0
	cede.sprite.show()
	
	if spawning_tween and spawning_tween.is_running():
		spawning_tween.kill()
	cede.is_active = true
