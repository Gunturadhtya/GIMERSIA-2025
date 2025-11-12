extends VBoxContainer

@onready var music_slider: HSlider = $HBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $HBoxContainer2/SfxSlider

var music_bus_index: int
var sfx_bus_index: int

func _ready():
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")

	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

func _on_music_slider_changed(value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_index, db)
	AudioServer.set_bus_mute(music_bus_index, value < 0.01)

func _on_sfx_slider_changed(value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(sfx_bus_index, db)
	AudioServer.set_bus_mute(sfx_bus_index, value < 0.01)
