extends Button

# Get references to the nodes we need to control
@onready var left_icon: TextureRect = $HBoxContainer/LeftIcon
@onready var right_icon: TextureRect = $HBoxContainer/RightIcon
@onready var hbox_container: HBoxContainer = $HBoxContainer # <-- Get the container

# Store the original position of the container
var _original_container_pos: Vector2

func _ready():
	# Store the container's starting position
	_original_container_pos = hbox_container.position

	# --- Connect the Button's own signals to our functions ---
	
	# When the mouse enters or leaves the button area
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# When the button is pressed down (clicked)
	button_down.connect(_on_button_down)
	
	# When the button is released
	button_up.connect(_on_button_up)


# --- Signal Functions ---

func _on_mouse_entered():
	# Show the icons (like your "center" image)
	left_icon.show()
	right_icon.show()

func _on_mouse_exited():
	# Hide the icons
	left_icon.hide()
	right_icon.hide()

func _on_button_down():
	# Move the whole container down (like your "bottom" image)
	hbox_container.position.y = _original_container_pos.y + 3 # Move 3 pixels down

func _on_button_up():
	# Move the whole container back to its original spot
	hbox_container.position.y = _original_container_pos.y
