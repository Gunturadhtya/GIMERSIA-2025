extends LevelState



func enter(previous_state_path: String, data := {}) -> void:
	level.rythim_manager.beat_start()
	print("Game Started")

func update(_delta: float) -> void:
	if level.player.lives <= 0:
		finished.emit(GAME_OVER)
		return
	
	if level.current_cleared_cube >= level.target_cleared_cube:
		finished.emit(LEVEL_CLEARED)
		return
