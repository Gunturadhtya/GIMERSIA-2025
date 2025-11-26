extends PlayerState

var hop_tween: Tween
var next_move

func enter(previous_state_path: String, data := {}) -> void:
	player.has_iframe = true
	player.has_moved = true
	if hop_tween and hop_tween.is_running():
		hop_tween.kill()
	
	if player.input_buffer != Vector2i.ZERO:
		next_move = player.input_buffer
		player.input_buffer = Vector2i.ZERO
		
		if next_move == moves[0]:
			player.facing_to = 0
			player.animation_player.play("hop_up")
		elif next_move == moves[1]:
			player.facing_to = 1
			player.animation_player.play("hop_right")
		elif next_move == moves[2]:
			player.facing_to = 2
			player.animation_player.play("hop_left")
		elif next_move == moves[3]:
			player.facing_to = 3
			player.animation_player.play("hop_down")
		
		var target_grid_pos = player.current_grid_pos + next_move
		player.target_grid_pos = target_grid_pos
		_start_hop(target_grid_pos)
		
	else:
		player.target_grid_pos = player.current_grid_pos
		finished.emit(IDLE, {"next_move" : Vector2i.ZERO})

func handle_input(_event: InputEvent) -> void:
	if not _event.is_pressed() or _event.is_echo():
		return

	var move_dir = Vector2i.ZERO
	
	if _event.is_action("Up"):
		move_dir = moves[0]
	elif _event.is_action("Right"):
		move_dir = moves[1]
	elif _event.is_action("Left"):
		move_dir = moves[2]
	elif _event.is_action("Down"):
		move_dir = moves[3]
	
	player.input_buffer = move_dir
	
func _start_hop(target_grid_pos: Vector2i):
	player.is_hopping = true
	
	AudioAutoloader.playPlayerJumpSound()
	
	player.last_song_pos = player.conductor.song_position_in_beats
	
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
	
	player.last_grid_pos = player.current_grid_pos
	player.has_iframe = false
	finished.emit(LANDING, data)
	
