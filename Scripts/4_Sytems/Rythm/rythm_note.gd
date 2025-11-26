extends Sprite2D
class_name RhythmNote

var target_beat: int      # The exact beat number this note should hit center
var appear_time: float    # How many beats "early" does this note appear?
var start_pos: Vector2    # Where it spawns (e.g., Left side)
var end_pos: Vector2      # Where it hits (Center)
var conductor: Node       # Reference to conductor

func setup(_conductor, _target_beat, _appear_time, _start, _end):
	conductor = _conductor
	target_beat = _target_beat
	appear_time = _appear_time
	start_pos = _start
	end_pos = _end
	
	global_position = start_pos

func _process(_delta):
	if not conductor: 
		return
	var current_beat = conductor.song_position_in_beats
	var beats_left = target_beat - current_beat
	
	var percent = beats_left / appear_time
	
	global_position = end_pos.lerp(start_pos, percent)
	
	if beats_left <= 0.5:
		set_texture(load("res://Assets/UI/rythm/line_active.png"))
	
	if beats_left < -0.01:
		queue_free()
