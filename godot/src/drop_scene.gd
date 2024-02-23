extends Node2D

@export var scene: PackedScene
@export var drop_angle := PI/6
@export var height_distance := 150
@export var drop_time := 0.8

func _ready():
	var node = scene.instantiate()
	node.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().current_scene.add_child(node)
	
	var tw = create_tween().set_parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	node.global_position = global_position + Vector2.UP.rotated(drop_angle) * height_distance
	node.scale = Vector2(1.4, 1.4)
	tw.tween_property(node, "global_position", global_position, drop_time)
	tw.tween_property(node, "scale", Vector2.ONE, drop_time)

	await tw.finished
	node.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
