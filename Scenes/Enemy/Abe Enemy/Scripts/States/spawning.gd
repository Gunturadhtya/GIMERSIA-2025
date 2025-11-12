extends AbeState

var spawning_tween: Tween
var move_counter: int = 0
var has_player_spawned: bool = false

func enter(previous_state_path: String, data := {}) -> void:
	abe.is_active = false
	abe.current_grid_pos = abe.spawn_grid_pos
	abe.global_position = abe.world.get_screen_pos_for_cell(abe.current_grid_pos)
	move_counter = 0
	print("test")
	has_player_spawned = false
	abe.sprite.hide()
	
	TurnManager.player_turn_taken.connect(_on_player_turn)

func _on_player_turn(_move_dir: Vector2i):
	if has_player_spawned:
		return

	move_counter += 1
	print(move_counter)
	if move_counter >= abe.target_move_counter:
		TurnManager.player_turn_taken.disconnect(_on_player_turn)
		_start_spawn_animation()

func _start_spawn_animation():
	abe.sprite.show()
	
	spawning_tween = abe.create_tween()
	spawning_tween.set_loops(4)
	spawning_tween.set_parallel(false)

	spawning_tween.tween_property(
		abe.sprite, "modulate:a", 0.2, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	spawning_tween.tween_property(
		abe.sprite, "modulate:a", 1.0, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await spawning_tween.finished
	abe.is_active = true
	finished.emit(IDLE)

func exit():
	
	if TurnManager.player_turn_taken.is_connected(_on_player_turn):
		TurnManager.player_turn_taken.disconnect(_on_player_turn)
	
	abe.sprite.modulate.a = 1.0
	abe.sprite.show()
	
	if spawning_tween and spawning_tween.is_running():
		spawning_tween.kill()
	abe.is_active = true
