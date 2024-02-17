extends CharacterBody2D

@export var accel := 800
@export var speed := 100
@export var roll_speed := 300
@export var attack_rate := 0.5
@export var rolling_cooldown := 1.0

@onready var player_input = $PlayerInput
@onready var animation_player = $AnimationPlayer
@onready var body = $Body
@onready var hand_root = $HandRoot
@onready var collision_shape_2d = $HandRoot/HitBox/CollisionShape2D

var can_attack = true

var can_roll = true
var rolling = false

func _ready():
	collision_shape_2d.disabled = true
	
	player_input.just_pressed.connect(func(ev: InputEvent):
		if ev.is_action_pressed("attack") and can_attack:
			can_attack = false
			get_tree().create_timer(attack_rate).timeout.connect(func(): can_attack = true)
			
			collision_shape_2d.disabled = false
			await get_tree().create_timer(0.1).timeout
			collision_shape_2d.disabled = true
		
		if ev.is_action_pressed("roll") and not rolling and can_roll:
			var motion = _get_motion()
			if motion:
				velocity += motion * roll_speed
				can_roll = false
				get_tree().create_timer(rolling_cooldown).timeout.connect(func(): can_roll = true)
				
				rolling = true
				animation_player.play("roll")
				await animation_player.animation_finished
				rolling = false
	)

func _get_motion():
	var motion = Vector2(
		player_input.get_action_strength("move_right") - player_input.get_action_strength("move_left"),
		player_input.get_action_strength("move_down") - player_input.get_action_strength("move_up"),
	)
	return motion.normalized()

func _physics_process(delta):
	var motion = _get_motion()
	var aim_dir = global_position.direction_to(get_global_mouse_position())
	body.scale.x = -1 if aim_dir.x < 0 else 1
	hand_root.global_rotation = Vector2.RIGHT.angle_to(aim_dir)
	
	if not rolling:
		animation_player.play("idle" if motion.length() == 0 else "move")
	
	velocity = velocity.move_toward(motion * speed, accel * delta)
	move_and_slide()
