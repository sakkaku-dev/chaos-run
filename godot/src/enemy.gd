extends CharacterBody2D

@export var speed := 50
@export var accel := 500

@onready var player := get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	var dir = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(dir * speed, accel * delta)
	move_and_slide()


func _on_hurtbox_knockback(dir):
	velocity += dir


func _on_health_zero_health():
	queue_free()