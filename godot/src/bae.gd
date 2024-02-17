extends CharacterBody2D

signal died()
signal chaos_meter_changed(value, max_value)

@export var accel := 800
@export var speed := 100
@export var roll_speed := 300

@export var max_chaos_meter := 100
@export var chaos_meter_bar: ProgressBar
@export var gameover: Control

@onready var roll_rate_limiter = $RollRateLimiter

@onready var player_input = $PlayerInput
@onready var animation_player = $AnimationPlayer
@onready var body = $Body
@onready var hand_root = $HandRoot
@onready var normal_hitbox = $HandRoot/HitBox
@onready var special_hitbox = $SpecialHitBox

@onready var chaos_meter := 0.0:
	set(v):
		chaos_meter = clamp(v, 0, max_chaos_meter)
		chaos_meter_changed.emit(v, max_chaos_meter)
		chaos_meter_bar.value = v

var rolling := false

func _ready():
	self.chaos_meter = 0.0
	gameover.hide()
	chaos_meter_bar.max_value = max_chaos_meter
	chaos_meter_bar.value = 0
	
	player_input.just_pressed.connect(func(ev: InputEvent):
		if ev.is_action_pressed("attack"):
			normal_hitbox.attack()
		
		if ev.is_action_pressed("roll") and not roll_rate_limiter.should_wait():
			var motion = _get_motion()
			if motion:
				velocity += motion * roll_speed
				roll_rate_limiter.run()
				
				rolling = true
				animation_player.play("roll")
				await animation_player.animation_finished
				rolling = false
				
		if ev.is_action_pressed("special_attack") and chaos_meter >= max_chaos_meter:
			self.chaos_meter = 0
			special_hitbox.attack()
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


func _on_hit_box_hit():
	self.chaos_meter += 5.0

func _on_hurt_box_hit(dmg):
	self.chaos_meter += 10.0

func _on_health_zero_health():
	died.emit()
	gameover.show()

