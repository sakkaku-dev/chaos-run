class_name HitBox
extends Area2D

signal hit()
signal attack_start()
signal attack_finish()

@export var oneshot = true
@export var damage := 1
@export var damage_value: NumberValue
@export var knockback_force := 0
@export var attack_time := 0.1
@export var rate_limiter: RateLimiter

@onready var collision := $CollisionShape2D

func _ready():
	if collision and oneshot:
		collision.disabled = true
	
	area_entered.connect(func(area):
		if area is HurtBox:
			_do_damage(area)
	)

func attack():
	if rate_limiter:
		if rate_limiter.should_wait(): return
		rate_limiter.run()
	
	attack_start.emit()
	collision.disabled = false
	await get_tree().create_timer(attack_time).timeout
	collision.disabled = true
	attack_finish.emit()

func _do_damage(area: HurtBox):
	var dmg = damage_value.get_value() if damage_value else damage
	var knockback_dir = global_position.direction_to(area.global_position)
	if area.damage(dmg, knockback_dir * knockback_force):
		hit.emit()
	
