extends CharacterBody2D

signal died()

@export var speed := 80
@export var accel := 600

@onready var player := get_tree().get_first_node_in_group("player")
@onready var soft_collision = $SoftCollision

func _physics_process(delta):
	var dir = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(dir * speed, accel * delta)
	velocity += soft_collision.get_push_vector() * delta
	
	move_and_slide()


func _on_hurtbox_knockback(dir):
	velocity += dir


func _on_health_zero_health():
	died.emit()
	queue_free()

func get_nearby_enemy_count():
	return soft_collision.get_overlapping_areas().size()
