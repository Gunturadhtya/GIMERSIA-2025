extends Node



@export var debug_mode: bool = false
@export var player: Player

@onready var music_player = $MusicPlayer
@onready var debug_label = $DebugLayer/Label
@onready var debug_layer = $DebugLayer

# Rhythm Stats
var current_map: BeatMap
var current_bpm: float = 0.0
var sec_per_beat: float = 0.0
var song_position_in_beats: float = 0.0
var last_reported_beat: int = 0
var last_audio_time: float = 0.0
var is_active: bool = false

func _ready():
	debug_layer.visible = debug_mode

func load_map(map: BeatMap):
	current_map = map
	music_player.stream = map.audio_stream
	_update_bpm(map.initial_bpm)
	song_position_in_beats = 0.0
	last_reported_beat = 0
	last_audio_time = 0.0

func start_music():
	music_player.play()
	is_active = true

func stop_music():
	music_player.stop()
	is_active = false

func _process(delta: float):
	if not is_active: 
		return

	var current_audio_time = music_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	current_audio_time -= current_map.offset_seconds
	
	var audio_delta = current_audio_time - last_audio_time
	if audio_delta < 0: 
		audio_delta = delta 
	last_audio_time = current_audio_time
	
	song_position_in_beats += (audio_delta * current_bpm) / 60.0

	if int(song_position_in_beats) > last_reported_beat:
		last_reported_beat = int(song_position_in_beats)
		GameStates.beat_hit.emit(last_reported_beat)
		AudioAutoloader.playTickSound()
		
		# checks if player has moved, then increments game_turn
		if player.has_moved:
			GameStates.game_turn += 1
		
		if current_map.bpm_changes.has(last_reported_beat):
			_update_bpm(current_map.bpm_changes[last_reported_beat])

	if debug_mode:
		debug_label.text = "BPM: %s\nBeat: %d\nGameTurn: %d\nSub-beat: %.2f" % [current_bpm, last_reported_beat, GameStates.game_turn, fmod(song_position_in_beats, 1.0)]

func _update_bpm(new_bpm: float):
	current_bpm = new_bpm
	sec_per_beat = 60.0 / current_bpm
