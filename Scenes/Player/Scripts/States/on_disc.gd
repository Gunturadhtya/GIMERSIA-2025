extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if not data.has("disc"):
		finished.emit(IDLE)
		return
		
	disc_node = data["disc"]
	GameStates.on_ride_disc = true
	disc_node.start_ride(player)

func update(_delta: float) -> void:
	if not GameStates.on_ride_disc:
		_on_ride_finished()

func _on_ride_finished():
	finished.emit(IDLE)
