extends HitBox

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $CollisionShape2D/AnimatedSprite2D

@onready var original_pos = collision_shape_2d.position

func _ready():
	super._ready()
	attack()
	attack_finish.connect(func(): queue_free())

func apply(res: HitBoxAttackResource):
	animated_sprite_2d.sprite_frames = res.animation
	animated_sprite_2d.play("default")
	
	collision_shape_2d.shape = res.attack_shape
	collision_shape_2d.position = original_pos + res.offset
	
	
	damage = res.damage
	attack_time = res.attack_time
	knockback_force = res.knockback
