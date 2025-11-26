extends CanvasLayer

enum Match {PERFECT, OK, MISS}

var NORMAL_CIRCLE = load("res://Assets/UI/rythm/circle.png")
var MISS_CIRCLE = load("res://Assets/UI/rythm/circle_miss.png")
var OK_CIRCLE = load("res://Assets/UI/rythm/circle_ok.png")
var PERFECT_CIRCLE = load("res://Assets/UI/rythm/circle_perfect.png")

@export var conductor: Node 
@export var player: Player
@export var note_scene: PackedScene

@export var approach_beats: float = 2.0
var last_spawned_beat: int = 0
var last_processed_beat: int = -1

@onready var center_pos = $CenterSpawnPoint.global_position
@onready var left_spawn_pos = $LeftSpawnPoint.global_position 
@onready var right_spawn_pos = $RightSpawnPoint.global_position

@onready var beat_sprite = $Sprite2D
@onready var right_progress_bar = $right_progress_bar
@onready var left_progress_bar = $left_progress_bar

@onready var left_timing_window = $LTimingWindowIndicator
@onready var right_timing_window = $RTimingWindowIndicator

@onready var beat_label: Label = $BeatLabel
@onready var beat_num_label: Label = $BeatNumLabel

@onready var star_container: HBoxContainer = $StarContainer

func _ready() -> void:
	if conductor:
		GameStates.beat_hit.connect(_on_beat_hit)
		last_spawned_beat = int(conductor.song_position_in_beats)
		#if conductor.debug_mode:
			#left_timing_window.visible = true
			#right_timing_window.visible = true
	
	right_progress_bar.max_value = 1.0
	left_progress_bar.max_value = 1.0
	beat_label.set_text("")

func _process(_delta: float) -> void:
	if not conductor or not conductor.is_active:
		return
	
	#var beat_progress = fmod(conductor.song_position_in_beats, 1.0)
	#var time_left_visual = 1.0 - beat_progress
	#left_progress_bar.visible = true
	#right_progress_bar.visible = true
	#left_progress_bar.value = time_left_visual
	#right_progress_bar.value = time_left_visual #uncomment this if you want progress bar
	
	beat_num_label.set_text("%d/256"%[GameStates.game_turn])
	
	if GameStates.game_turn > get_parent().star_thresholds.get(3, 0):
		star_container.get_child(0).visible = false
	
	if GameStates.game_turn > get_parent().star_thresholds.get(2, 0):
		star_container.get_child(1).visible = false
	
	if player.is_hopping and player.last_hop_beat != last_processed_beat:
		_validate_player_hit()
	
	_handle_note_spawning()

func _validate_player_hit():
	var target_beat = round(player.last_song_pos)
	
	var diff_beats = abs(player.last_song_pos - target_beat)
	
	var diff_seconds = diff_beats * conductor.sec_per_beat
	
	print("Hit Offset: %.3f sec" % diff_seconds)

	if diff_seconds <= 0.1: 
		AudioAutoloader.playPerfectSound()
		
		#print("PERFECT")
		beat_label.set_text("PERFECT")
		player.current_match = Match.PERFECT
		_beat_indicator()
	elif diff_seconds <= 0.25:
		
		#print("OK")
		beat_label.set_text("OK")
		player.current_match = Match.OK
		_beat_indicator()
	else:
		
		beat_label.set_text("MISS")
		player.current_match = Match.MISS
		_beat_indicator()
		#print("Miss (Timing off)")

	last_processed_beat = player.last_hop_beat

func _handle_note_spawning():
	var future_beat = conductor.song_position_in_beats + approach_beats
	
	if int(future_beat) > last_spawned_beat:
		last_spawned_beat = int(future_beat)
		spawn_visual_note(last_spawned_beat)

func spawn_visual_note(target_beat_num: int):
	if not note_scene: return
	
	var note_right = note_scene.instantiate()
	var note_left = note_scene.instantiate()
	add_child(note_right)
	add_child(note_left)
	
	note_right.setup(conductor, target_beat_num, approach_beats, right_spawn_pos, center_pos + Vector2(20, 0))
	note_left.setup(conductor, target_beat_num, approach_beats, left_spawn_pos, center_pos  + Vector2(-20, 0))

func _on_beat_hit(beat_num: int):
	if player.last_hop_beat < beat_num and !GameStates.on_ride_disc and GameStates.game_start:
		player.current_match = GameStates.Match.MISS
		beat_label.set_text("MISS")
		_screen_shake()
		_beat_indicator()

func _beat_indicator():
	match player.current_match:
		GameStates.Match.PERFECT:
			beat_sprite.set_texture(PERFECT_CIRCLE)
		GameStates.Match.OK:
			beat_sprite.set_texture(OK_CIRCLE)
		GameStates.Match.MISS:
			beat_sprite.set_texture(MISS_CIRCLE)
	
	await get_tree().create_timer(0.3).timeout
	
	beat_sprite.set_texture(NORMAL_CIRCLE)
	

func _screen_shake():
	var cam = get_viewport().get_camera_2d()
	if not cam: return
	
	var tween = create_tween()
	# Shake heavily then return to zero
	for i in range(round(GameStates.SHAKE_SPEED)):
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * GameStates.SHAKE_INTENSITY
		tween.tween_property(cam, "offset", random_offset, GameStates.SHAKE_DURATION / GameStates.SHAKE_SPEED)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)
