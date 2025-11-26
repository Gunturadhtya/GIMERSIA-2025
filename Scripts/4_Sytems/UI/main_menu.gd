extends CanvasLayer

func _on_start_button_pressed() -> void:
	AudioAutoloader.playClick()
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/stage_1.tscn"))


func _on_quit_button_pressed() -> void:
	AudioAutoloader.playClick()
	get_tree().quit(0)


func _on_level_selection_button_pressed() -> void:
	AudioAutoloader.playClick()
	get_tree().change_scene_to_packed(GameStates.scene_level_selector)
