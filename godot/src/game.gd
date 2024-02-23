extends Node2D

@export var player: CharacterBody2D
@export var enemy_scene: PackedScene
@export var distance_to_player := 200

@export var enemy_count_label: Label
@export var enemy_killed_label: Label

@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var tile_map = $TileMap

var enemy_count := 0
var enemy_killed := 0

func _ready():
	enemy_spawn_timer.timeout.connect(func(): _spawn_enemy())
	_update_labels()

func _update_labels():
	enemy_count_label.text = "Enemies: %s" % enemy_count
	enemy_killed_label.text = "Killed: %s" % enemy_killed

func _spawn_enemy():
	var enemy = enemy_scene.instantiate()
	tile_map.add_child(enemy)
	
	var left = 0
	var right = TAU
	#if player.velocity:
		#left = player.velocity.rotated(-PI/2).angle()
		#right = player.velocity.rotated(PI/2).angle()
	
	var offset = Vector2.RIGHT * distance_to_player
	offset = offset.rotated(randf_range(left, right))
	enemy.global_position = player.global_position + offset
	enemy.died.connect(func():
		enemy_count -= 1
		enemy_killed += 1
		_update_labels()
	)
	enemy_count += 1
	_update_labels()
