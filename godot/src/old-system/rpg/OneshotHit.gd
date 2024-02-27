extends HitBox

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $CollisionShape2D/AnimatedSprite2D

@onready var original_pos = collision_shape_2d.position

@export var autostart := true

func _ready():
	super._ready()
	
	if autostart:
		attack_finish.connect(func(): queue_free())

func apply(res: HitBoxAttackResource):
	animated_sprite_2d.sprite_frames = res.animation
	animated_sprite_2d.play("default")
	animated_sprite_2d.rotation_degrees = res.animation_rotation
	animated_sprite_2d.offset = res.animation_offset
	
	update_hit_resource(res)
	collision_shape_2d.position = original_pos + res.offset
	collision_shape_2d.disabled = true

	await get_tree().create_timer(res.hit_delay).timeout
