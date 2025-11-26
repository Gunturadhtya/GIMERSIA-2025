extends EntityState

var falling_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()
	_start_falling()

func _start_falling():
	falling_tween = owner.create_tween()
	
	if owner is Player:
		AudioAutoloader.playPlayerDyingSound()
	elif owner is Abe or owner is Cede:
		AudioAutoloader.playAbeDyingSound()
	
	falling_tween.set_parallel(true)
	
	falling_tween.tween_property(
		owner,                               
		"global_position:y",                 
		owner.global_position.y + 600,       
		1.2                                  
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		owner.sprite,                              
		"scale",                             
		Vector2.ZERO,                        
		DEFAULT_SCALE.y + 0.2                                  
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	falling_tween.tween_property(
		owner.sprite,                              
		"modulate:a",                        
		0.0,                                 
		1.0                                  
	).set_trans(Tween.TRANS_SINE)
	
	await falling_tween.finished
	
	if owner is Player:
		print("Player")
		finished.emit(DEAD)
	elif owner is Abe or owner is Cede:
		print("Abe or Cede")
		finished.emit(SPAWNING)

func exit():
	if falling_tween and falling_tween.is_running():
		falling_tween.kill()

	owner.sprite.scale = DEFAULT_SCALE
	owner.sprite.modulate.a = 1.0
