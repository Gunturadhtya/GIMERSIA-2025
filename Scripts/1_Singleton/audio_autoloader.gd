extends Node

@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var perfect_sound: AudioStreamPlayer2D = $PerfectSound
@onready var tick_sound: AudioStreamPlayer2D = $TickSound
@onready var abe_dying_sound: AudioStreamPlayer2D = $AbeDyingSound
@onready var abe_jump_sound: AudioStreamPlayer2D = $AbeJumpSound
@onready var player_dying_sound: AudioStreamPlayer2D = $PlayerDyingSound
@onready var player_jump_sound: AudioStreamPlayer2D = $PlayerJumpSound
@onready var player_jump_active_sound: AudioStreamPlayer2D = $PlayerJumpActiveTileSound
@onready var star_1_sound: AudioStreamPlayer2D = $Star1Sound
@onready var star_2_sound: AudioStreamPlayer2D = $Star2Sound
@onready var star_3_sound: AudioStreamPlayer2D = $Star3Sound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound

const MIN_PITCH: float = 0.9
const MAX_PITCH: float = 1.1

func playHitSound():
	hit_sound.play()

func playPerfectSound():
	_play_with_variation(perfect_sound)
	perfect_sound.play()

func playTickSound():
	tick_sound.play()

func playAbeDyingSound():
	abe_dying_sound.play()

func playAbeJumpSound():
	_play_with_variation(abe_jump_sound)

func playPlayerDyingSound():
	player_dying_sound.play()

func playPlayerJumpSound():
	_play_with_variation(player_jump_sound)

func playPlayerJumpActiveSound():
	player_jump_active_sound.play()

# Play the generic Click sound
func playClick() -> void:
	_play_with_variation(click_sound)

# Play a specific star sound by number (1, 2, or 3)
func playStar1():
	_play_with_variation(star_1_sound)

func playStar2():
	_play_with_variation(star_2_sound)

func playStar3():
	_play_with_variation(star_3_sound)

# --- INTERNAL HELPER FUNCTIONS ---

# Helper to play sound with slight pitch randomization
func _play_with_variation(player: AudioStreamPlayer2D) -> void:
	if player.stream == null:
		return
	
	# Randomize pitch slightly so it doesn't sound robotic
	player.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	player.play()
