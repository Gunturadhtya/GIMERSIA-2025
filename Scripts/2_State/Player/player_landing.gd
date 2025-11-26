extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.has_iframe = false
	player.current_grid_pos = data["target_grid_pos"]
	
	var overlapping_areas = player.hitbox.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("disc"):
			finished.emit(ON_DISC, {"disc":area.get_parent()})
			return
	
	#print(player.current_grid_pos)
	if _is_valid_cell(player.current_grid_pos):
		# Cheks enemy position and run stomp logic if detected, then switch state
		var enemy = _get_enemy_at_position(player.current_grid_pos)
		# Enemy get stomped (killed)
		if enemy:
			_handle_stomp_logic(enemy)
			player.world.on_player_landed(player.current_grid_pos)
			finished.emit(IDLE, {"next_move" : data["next_move"]})
		else:
			match player.current_match:
				GameStates.Match.PERFECT:
					_tween_bounce(true)
				GameStates.Match.OK:
					_tween_bounce(false)
				GameStates.Match.MISS:
					_tween_shake()
			player.world.on_player_landed(player.current_grid_pos)
			finished.emit(IDLE, {"next_move" : data["next_move"]})
	else:
		finished.emit(FALLING)

# Handles stomp logic when player is on enemy grid
func _handle_stomp_logic(enemy_node: Node2D):
	
	 #Check if enemy has iframe then stop the stomp logic operation
	if "has_iframe" in enemy_node and enemy_node.has_iframe:
		print("enemy iframe", enemy_node.has_iframe) 
		return

	AudioAutoloader.playAbeDyingSound()
	
	var deduction = 0
	var label_text = ""
	var label_color = Color.WHITE
	
	# Determine game_turn subtraction and label text
	match player.current_match:
		GameStates.Match.PERFECT:
			deduction = player.perfect_deduction
			label_text = "%s, -%d turn" % [player.perfect_label_text, deduction]
			label_color = Color.ORANGE
		GameStates.Match.OK:
			deduction = player.ok_deduction
			label_text = "%s, -%d turn" % [player.ok_label_text, deduction]
			label_color = Color.WEB_GREEN
		GameStates.Match.MISS:
			deduction = player.miss_deduction
			label_text = "%s, -%d turn" % [player.miss_label_text, deduction]
			label_color = Color.DIM_GRAY
			
	# Set the floating label
	if player.floating_label:
		var label_instance = player.floating_label.instantiate()
		player.get_parent().add_child(label_instance)
		
		#Position it above the enemy
		label_instance.global_position = enemy_node.global_position + Vector2(-60, -150)
		
		#Set text and color
		if label_instance.has_method("set_text_and_color"):
			label_instance.set_text_and_color(label_text, label_color)
	else:
		print("Warning: floating_label_scene not assigned in Player!")

	# Game Turn reduced based on stomp
	if deduction > 0:
		GameStates.game_turn -= deduction
		if GameStates.game_turn < 0:
			GameStates.game_turn = 0
		print("Debug: Game Turn updated to ", GameStates.game_turn)
	
	# Kills the enemy, no longer respawn
	enemy_node.queue_free()

# get enemy grid position
func _get_enemy_at_position(grid_pos: Vector2i) -> Node2D:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.current_grid_pos == grid_pos and enemy.is_active:
			return enemy
	return null

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return player.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

func _tween_shake() -> void:
	var cam = get_viewport().get_camera_2d()
	if not cam: return
	
	var tween = create_tween()
	# Shake heavily then return to zero
	for i in range(5):
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * GameStates.SHAKE_INTENSITY
		tween.tween_property(cam, "offset", random_offset, GameStates.SHAKE_DURATION / 5.0)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)

func _tween_bounce(is_perfect: bool) -> void:
	var cam = get_viewport().get_camera_2d()
	if not cam: return
	
	var intensity = GameStates.BOUNCE_OFFSET_PERFECT if is_perfect else GameStates.BOUNCE_OFFSET_OK
	var time = 0.15 if is_perfect else 0.1
	
	var tween = create_tween()
	# Dip the camera down (impact weight) then bounce back up
	tween.tween_property(cam, "offset:y", intensity, time * 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(cam, "offset:y", 0.0, time * 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
