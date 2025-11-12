extends PlayerState

var falling_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()
	
	_start_falling()

func _start_falling():
	falling_tween = player.create_tween()

	falling_tween.set_parallel(true)
	
	falling_tween.tween_property(
		player,                               
		"global_position:y",                 
		player.global_position.y + 600,       
		1.2                                  
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		player.sprite,                              
		"scale",                             
		Vector2.ZERO,                        
		DEFAULT_SCALE.y + 0.2                                  
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		player.sprite,                              
		"modulate:a",                        
		0.0,                                 
		1.0                                  
	).set_trans(Tween.TRANS_SINE)
	
	await falling_tween.finished

	finished.emit(DEAD)

func exit():
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()

	player.sprite.scale = DEFAULT_SCALE
	player.sprite.modulate.a = 1.0
