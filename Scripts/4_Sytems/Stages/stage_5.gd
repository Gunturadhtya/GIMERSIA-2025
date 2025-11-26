class_name Stage5 extends Stage

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/stage_6.tscn"))
