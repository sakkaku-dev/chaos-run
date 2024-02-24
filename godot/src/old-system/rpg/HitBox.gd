class_name HitBox
extends Area2D

signal hit()
signal attack_start()
signal attack_finish()

@export var damage := 1
@export var knockback_force := 0
@export var attack_time := 0.1

@onready var collision := $CollisionShape2D

func _ready():
	area_entered.connect(func(area):
		if area is HurtBox:
			_do_damage(area)
	)

func update_hit_resource(resource: HitBoxAttackResource):
	damage = resource.damage
	knockback_force = resource.knockback
	attack_time = resource.attack_time
	collision.shape = resource.attack_shape

func attack():
	attack_start.emit()
	collision.disabled = false
	await get_tree().create_timer(attack_time).timeout
	collision.disabled = true
	attack_finish.emit()

func _do_damage(area: HurtBox):
	var dmg = damage
	var knockback_dir = global_position.direction_to(area.global_position)
	if area.damage(dmg, knockback_dir * knockback_force):
		hit.emit()
		
		#if get_collision_mask_value(5):
		GameManager.hit.emit()
	
