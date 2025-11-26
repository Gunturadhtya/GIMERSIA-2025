extends Control

func _change_to_stage(stage: int):
	AudioAutoloader.playClick()
	get_tree().change_scene_to_file(GameStates.levels[stage])

func _on_back_button_pressed() -> void:
	AudioAutoloader.playClick()
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)
