extends CanvasLayer

@onready var retry_button = $RetryButton
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	GameStates.score_updated.connect(_on_score_updated)
	
	_on_score_updated(GameStates.score)

func _on_score_updated(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score
