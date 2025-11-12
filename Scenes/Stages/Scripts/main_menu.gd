extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/1_Stage/stage_1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)


func _on_level_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/level_selection/level_selection.tscn")
