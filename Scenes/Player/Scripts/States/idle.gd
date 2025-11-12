extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if data.has("next_move"):
		if data["next_move"] == Vector2i(1,0):
			player.animation_player.play("idle_up")
		elif data["next_move"] == Vector2i(0,1):
			player.animation_player.play("idle_right")
		elif data["next_move"] == Vector2i(0,-1):
			player.animation_player.play("idle_left")
		elif data["next_move"] == Vector2i(-1,0):
			player.animation_player.play("idle_down")
	else:
		player.animation_player.play("idle_down")
	
	if player.input_buffer != Vector2i.ZERO:
		finished.emit(HOPPING)

func handle_input(_event: InputEvent) -> void:
	var move_dir = Vector2i.ZERO
	
	if _event.is_action_pressed("Up"):
		move_dir = Vector2i(1, 0)
	elif _event.is_action_pressed("Right"):
		move_dir = Vector2i(0, 1)
	elif _event.is_action_pressed("Left"):
		move_dir = Vector2i(0, -1)
	elif _event.is_action_pressed("Down"):
		move_dir = Vector2i(-1, 0)

	if move_dir != Vector2i.ZERO:
		player.input_buffer = move_dir
		TurnManager.player_turn_taken.emit(move_dir)
	finished.emit(HOPPING)
