class_name CedeState extends BaseState

const SPAWNING = "Spawning"
const IDLE = "Idle"
const HOPPING = "Hopping"
const LANDING = "Landing"
const FALLING = "Falling"

const DEFAULT_SCALE = Vector2(0.2, 0.2)

var cede: Cede
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	cede = owner as Cede
	assert(cede != null, "The CedeState state type must be used only in the cede scene. It needs the owner to be a Cede node.")
