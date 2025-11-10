extends AbeState

var falling_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	abe.is_active = false
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()
	
	_start_falling()

func _start_falling():
	falling_tween = abe.create_tween()

	falling_tween.set_parallel(true)
	
	falling_tween.tween_property(
		abe,                               
		"global_position:y",                 
		abe.global_position.y + 600,       
		1.2                                  
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		abe.sprite,                              
		"scale",                             
		Vector2.ZERO,                        
		DEFAULT_SCALE.y + 0.2                                  
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		abe.sprite,                              
		"modulate:a",                        
		0.0,                                 
		1.0                                  
	).set_trans(Tween.TRANS_SINE)
	
	await falling_tween.finished
	finished.emit(SPAWNING)

func exit():
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()

	abe.sprite.scale = DEFAULT_SCALE
	abe.sprite.modulate.a = 1.0
