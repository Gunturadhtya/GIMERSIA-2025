extends PlayerState

var hop_tween: Tween
var next_move

func enter(previous_state_path: String, data := {}) -> void:
	if hop_tween and hop_tween.is_running():
		hop_tween.kill()
	
	if player.input_buffer != Vector2i.ZERO:
		next_move = player.input_buffer
		player.input_buffer = Vector2i.ZERO
		
		if next_move == Vector2i(1, 0):
			player.animation_player.play("hop_up")
		elif next_move == Vector2i(0, 1):
			player.animation_player.play("hop_right")
		elif next_move == Vector2i(0,-1):
			player.animation_player.play("hop_left")
		elif next_move == Vector2i(-1, 0):
			player.animation_player.play("hop_down")
		
		var target_grid_pos = player.current_grid_pos + next_move
		
		_start_hop(target_grid_pos)
	else:
		finished.emit(IDLE, {"next_move" : Vector2i.ZERO})

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

func _start_hop(target_grid_pos: Vector2i):
	player.is_hopping = true
	var target_screen_pos = player.world.get_screen_pos_for_cell(target_grid_pos)
	
	hop_tween = player.create_tween()
	hop_tween.set_parallel(true) 
	hop_tween.tween_property(player, "global_position", target_screen_pos, 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	var arc_tween = player.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var hop_scale = DEFAULT_SCALE.y/2
	arc_tween.tween_property(player.sprite, "scale:y", DEFAULT_SCALE.y + hop_scale, 0.125) 
	arc_tween.tween_property(player.sprite, "scale:y", DEFAULT_SCALE.y, 0.125)
	
	await hop_tween.finished
	
	var data: Dictionary = {"target_grid_pos": target_grid_pos, "next_move" : next_move}
	finished.emit(LANDING, data)
	
