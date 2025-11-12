extends Control


@export var beat_per_minute: float = 70
@export var player: Player
var beat_per_second:float = 60/beat_per_minute

@onready var beat_timer = $BeatTimer
@onready var beat_indicator = $BeatIndicator
@onready var beat_sprite = $Sprite2D
@onready var right_progress_bar =  $right_progress_bar
@onready var left_progress_bar =  $left_progress_bar


func _ready() -> void:
	beat_timer.wait_time = beat_per_second
	beat_timer.one_shot = false
	beat_timer.connect("timeout", _on_beat_timer_timeout)
	right_progress_bar.value = 0
	right_progress_bar.max_value = beat_timer.wait_time * 100
	left_progress_bar.value = 0
	left_progress_bar.max_value = beat_timer.wait_time * 100

func _process(delta: float) -> void:
	if beat_timer.is_stopped():
		return
	
	left_progress_bar.value = beat_timer.time_left * 100
	right_progress_bar.value = beat_timer.time_left * 100

func beat_start():
	beat_timer.start()

func beat_pause():
	beat_timer.paused = true

func beat_resume():
	beat_timer.paused = false

func beat_stop():
	beat_timer.stop()

func _on_beat_timer_timeout():
	if player.is_hopping:
		beat_indicator.color = Color.GREEN
		beat_sprite.frame_coords = Vector2(1, 0)
		await get_tree().create_timer(0.2).timeout
		beat_indicator.color = Color.WHITE
		beat_sprite.frame_coords = Vector2(0, 0)
		return
	
	TurnManager.player_turn_taken.emit(Vector2i.ZERO)
	
	GameStates.reset_multiplier()
	beat_indicator.color = Color.RED
	beat_sprite.frame_coords = Vector2(1, 0)
	await get_tree().create_timer(0.2).timeout
	beat_indicator.color = Color.WHITE
	beat_sprite.frame_coords = Vector2(0, 0)
