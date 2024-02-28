extends CharacterBody2D

signal attack_finish()

@export var initial_force := 700
@export var deaccel := 1000

@onready var hit_box = $HitBox

func dive_to(dir: Vector2):
	velocity = dir * initial_force

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * deaccel)
	hit_box.scale.x = -1 if velocity.x < 0 else 1
	
	move_and_slide()
	
	if velocity.length() == 0:
		attack_finish.emit()
		queue_free()

func apply(hit_resource: HitBoxAttackResource):
	await hit_box.apply(hit_resource)
	hit_box.attack()
