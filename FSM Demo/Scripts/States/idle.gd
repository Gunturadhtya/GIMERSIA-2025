extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		finished.emit(WALKING)
