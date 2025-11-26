class_name Stage7 extends Stage

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/stage_8.tscn"))
