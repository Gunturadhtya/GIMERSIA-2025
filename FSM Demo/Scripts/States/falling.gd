extends PlayerStateDEMO

func physics_update(_delta: float) -> void:
	var input_direction_x = Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if player.is_on_floor():
		
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(WALKING)

func _check_enemy_collision() -> void:
	var collision = player.get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider and collider.is_in_group("Enemies"):
			pass
