class_name Player extends CharacterBody2D

signal hit_by_enemy

@export var world: Node2D
var current_grid_pos: Vector2i
var input_buffer: Vector2i = Vector2i.ZERO
var lives: int = 3
var is_hopping: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var hitbox: Area2D = $Hitbox

func _ready():
	current_grid_pos = world.get_spawn_pos()
	global_position = world.get_screen_pos_for_cell(current_grid_pos)
