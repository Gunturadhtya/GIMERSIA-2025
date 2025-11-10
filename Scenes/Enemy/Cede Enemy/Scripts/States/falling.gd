extends CedeState

var falling_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	cede.is_active = false
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()
	
	_start_falling()

func _start_falling():
	falling_tween = cede.create_tween()

	falling_tween.set_parallel(true)
	
	falling_tween.tween_property(
		cede,                               
		"global_position:y",                 
		cede.global_position.y + 600,       
		1.2                                  
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		cede.sprite,                              
		"scale",                             
		Vector2.ZERO,                        
		0.7                                  
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		cede.sprite,                              
		"modulate:a",                        
		0.0,                                 
		1.0                                  
	).set_trans(Tween.TRANS_SINE)
	
	await falling_tween.finished
	finished.emit(SPAWNING)

func exit():
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()

	cede.sprite.scale = Vector2(0.5, 0.5)
	cede.sprite.modulate.a = 1.0
