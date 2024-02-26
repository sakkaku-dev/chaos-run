extends Node2D

@export var enemy_scene: PackedScene
@export var attack_scene: PackedScene
@export var drop_scene: PackedScene
@export var rain_time := 8.0
@export var rain_spawn_gap_time := 0.5

@export var rain_modulate := Color.DARK_GRAY
@export var normal_modulate := Color.WHITE

@onready var canvas_modulate = $CanvasModulate
@onready var range = get_viewport_rect().size / 3

var raining_object

func _ready():
	GameManager.chaos_roll.connect(func(num):
		if num <= 3:
			raining_object = enemy_scene
			rain_spawn()
		else:
			raining_object = attack_scene
			rain_spawn(true)
		
		canvas_modulate.color = rain_modulate
		get_tree().create_timer(rain_time).timeout.connect(func():
			raining_object = null
			canvas_modulate.color = normal_modulate
		)
	)

func rain_spawn(towards_group = false):
	if not raining_object or get_tree().paused: return
	
	var dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var dist = randfn(50, 20)
	var pos = global_position + dir * dist
	
	if towards_group:
		pos = _get_random_enemy_group().global_position
	
	var obj = drop_scene.instantiate()
	obj.scene = raining_object
	obj.global_position = pos
	get_tree().current_scene.add_child(obj)
	
	get_tree().create_timer(rain_spawn_gap_time).timeout.connect(func(): rain_spawn(towards_group))

func _get_random_enemy_group():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var group_enemies := []
	for e in enemies:
		if e.get_nearby_enemy_count() > 6:
			group_enemies.append(e)
	
	if group_enemies.size() > 0:
		return group_enemies.pick_random()

	return enemies.pick_random()
