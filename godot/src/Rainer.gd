extends Node2D

@export var enemy_scene: PackedScene
@export var attack_scene: PackedScene
@export var drop_scene: PackedScene
@export var rain_time := 8.0
@export var rain_spawn_gap_time := 0.5

@onready var range = get_viewport_rect().size / 2

var raining_object

func _ready():
	GameManager.chaos_roll.connect(func(num):
		if num <= 3:
			raining_object = enemy_scene
		else:
			raining_object = attack_scene
		
		rain_spawn()
		get_tree().create_timer(rain_time).timeout.connect(func(): raining_object = null)
	)

func rain_spawn():
	if not raining_object or get_tree().paused: return
	
	var dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var dist = randf_range(0, 1)
	var pos = global_position + dir * range * dist
	
	var obj = drop_scene.instantiate()
	obj.scene = raining_object
	obj.global_position = pos
	get_tree().current_scene.add_child(obj)
	
	get_tree().create_timer(rain_spawn_gap_time).timeout.connect(rain_spawn)
