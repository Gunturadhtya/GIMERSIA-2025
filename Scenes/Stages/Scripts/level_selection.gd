extends Control

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/menu/main_menu.tscn")


func _on_stage_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/1_Tutorial/tutorial_1.tscn")


func _on_stage_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/2_Tutorial/tutorial_2.tscn")


func _on_stage_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/3_Tutorial/tutorial_3.tscn")


func _on_stage_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/1_Stage/stage_1.tscn")


func _on_stage_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/2_Stage/stage_2.tscn")


func _on_stage_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/3_Stage/stage_3.tscn")
