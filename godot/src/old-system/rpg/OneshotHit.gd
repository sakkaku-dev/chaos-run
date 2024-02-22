extends HitBox

@onready var collision_shape_2d = $CollisionShape2D
@onready var color_rect = $CollisionShape2D/ColorRect

@onready var original_pos = collision_shape_2d.position

func _ready():
	super._ready()
	attack()
	attack_finish.connect(func(): queue_free())

func apply(res: HitBoxAttackResource):
	collision_shape_2d.shape = res.attack_shape
	collision_shape_2d.position = original_pos + Vector2(res.offset, 0)
	color_rect.size = res.attack_shape.get_rect().size
	color_rect.position = -color_rect.size/2
	
	
	damage = res.damage
	attack_time = res.attack_time
	knockback_force = res.knockback
