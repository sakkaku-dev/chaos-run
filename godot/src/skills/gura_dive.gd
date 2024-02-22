extends CharacterBody2D

signal attack_finish()

@export var initial_force := 500
@export var deaccel := 800

@onready var sprite_2d = $Sprite2D

func dive_to(dir: Vector2):
	velocity = dir * initial_force

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * deaccel)
	sprite_2d.scale.x = -1 if velocity.x < 0 else 1
	
	move_and_slide()
	
	if velocity.length() == 0:
		attack_finish.emit()
		queue_free()
