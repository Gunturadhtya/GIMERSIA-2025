extends Node

@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var perfect_sound: AudioStreamPlayer2D = $PerfectSound
@onready var tick_sound: AudioStreamPlayer2D = $TickSound
@onready var abe_dying_sound: AudioStreamPlayer2D = $AbeDyingSound
@onready var abe_jump_sound: AudioStreamPlayer2D = $AbeJumpSound
@onready var player_dying_sound: AudioStreamPlayer2D = $PlayerDyingSound
@onready var player_jump_sound: AudioStreamPlayer2D = $PlayerJumpSound
@onready var player_jump_active_sound: AudioStreamPlayer2D = $PlayerJumpActiveTileSound

func playHitSound():
	hit_sound.play()

func playPerfectSound():
	perfect_sound.pitch_scale = randf_range(0.7, 1.5)
	perfect_sound.play()

func playTickSound():
	tick_sound.play()

func playAbeDyingSound():
	abe_dying_sound.play()

func playAbeJumpSound():
	# Slight pitch randomization helps prevent "ear fatigue" on repetitive sounds
	abe_jump_sound.pitch_scale = randf_range(0.9, 1.1)
	abe_jump_sound.play()

func playPlayerDyingSound():
	player_dying_sound.play()

func playPlayerJumpSound():
	player_jump_sound.pitch_scale = randf_range(0.9, 1.1)
	player_jump_sound.play()

func playPlayerJumpActiveSound():
	player_jump_active_sound.play()
