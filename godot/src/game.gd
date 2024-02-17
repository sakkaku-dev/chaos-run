extends Node2D

@export var player: Node2D
@export var enemy_scene: PackedScene
@export var distance_to_player := 200

@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var tile_map = $TileMap

func _ready():
	enemy_spawn_timer.timeout.connect(func(): _spawn_enemy())
	
func _spawn_enemy():
	var enemy = enemy_scene.instantiate()
	tile_map.add_child(enemy)
	
	var offset = Vector2.RIGHT * distance_to_player
	offset = offset.rotated(randf_range(0, TAU))
	enemy.global_position = player.global_position + offset
