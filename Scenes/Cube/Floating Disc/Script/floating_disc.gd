extends Node2D

signal ride_finished(final_world_position)

@export var target_marker: NodePath

var target_position: Vector2
var original_position: Vector2

func _ready():
	original_position = global_position
	
	if not target_marker.is_empty():
		target_position = get_node(target_marker).global_position

func start_ride(player: Player):
	var original_parent = player.get_parent()
	player.reparent(self)
	player.global_position = self.global_position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE) 
	
	var lift_position = global_position + Vector2(0, -400)
	tween.tween_property(self, "global_position", lift_position, 1.0)
	tween.tween_property(self, "global_position", target_position, 1.5)
	
	tween.tween_callback(self._on_tween_complete.bind(player, original_parent))

func _on_tween_complete(player: Player, original_parent):
	print("On Disc Finished (Tween Callback)") 
	
	player.reparent(original_parent)
	player.current_grid_pos = player.world.get_cell_for_global_pos(target_position)
	player.global_position = target_position
	
	GameStates.on_ride_disc = false
	global_position = original_position
