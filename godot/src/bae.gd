class_name Player
extends CharacterBody2D

signal died()
signal chaos_meter_changed(value, max_value)

@export var accel := 800
@export var speed := 100
@export var roll_speed := 300

@export var max_chaos_meter := 100.0
@export var max_cooldown_decrease := 0.5

@export var gameover: Control
@export var chaos_meter_bar: ProgressBar

@export var special_skill_slot: TextureRect
@export var attack_skill_slot: TextureRect
@export var defense_skill_slot: TextureRect

@onready var attack_timer = $AttackTimer
@onready var defense_timer = $DefenseTimer
@onready var special_timer = $SpecialTimer

@onready var attack_sound = $AttackTimer/AttackSound
@onready var defense_sound = $DefenseTimer/AttackSound

@onready var player_input = $PlayerInput
@onready var animation_player = $AnimationPlayer
@onready var body = $Body
@onready var hand_root = $HandRoot

@onready var collision_shape_2d = $HurtBox/CollisionShape2D

@onready var dice_ready_sound = $DiceReady
@onready var lose_sound = $LoseSound

@onready var chaos_meter := 0.0:
	set(v):
		chaos_meter = clamp(v, 0, max_chaos_meter)
		chaos_meter_changed.emit(v, max_chaos_meter)
		chaos_meter_bar.value = v
		chaos_meter_bar.max_value = max_chaos_meter
		
		if not dice_ready and chaos_meter >= max_chaos_meter:
			dice_ready = true
			dice_ready_sound.play()
		elif dice_ready and chaos_meter < max_chaos_meter - 1:
			dice_ready = false
		
		special_skill_slot.modulate = Color(.5, .5, .5, .8) if chaos_meter < max_chaos_meter and not rolling_dice else Color.WHITE
		
@onready var chaos_roll = $Skills/ChaosRoll
@onready var skill_map := {
	Skill.Type.AME_TELEPORT: $Skills/AmeTeleport,
	Skill.Type.KIARA_SWORD_SHIELD: $Skills/KiaraAttack,
	Skill.Type.CALLI_SCYTHE: $Skills/CalliScythe,
	Skill.Type.GURA_SHARK_DIVE: $Skills/GuraDive,
	Skill.Type.INA_TENTACLES: $Skills/InaTentacles,
}

var dice_ready := false
var attack_skill: Skill.Type
var defense_skill: Skill.Type

var follow_node
var rolling_dice := false

# not good but it's just a jam anyway
var enemy_count := 0

func _ready():
	animation_player.play("RESET")
	_roll_random_skills()
	_update_for_current_skills(true)
	self.chaos_meter = 0
	
	player_input.on_event.connect(func(ev: InputEvent):
		var chaos_percentage = (chaos_meter / max_chaos_meter)
		var chaos_cooldown_reduction = 1.0 - (chaos_percentage * (1.0 - max_cooldown_decrease))

		if not attack_timer.should_wait() and not follow_node:
			var skill_1: Skill = skill_map[attack_skill]
			if ev.is_action_pressed("attack"):
				skill_1.pressed(self)
			elif ev.is_action_released("attack"):
				attack_timer.run(skill_1.cooldown * chaos_cooldown_reduction)
				skill_1.released(self)
				attack_sound.play()
		
		if not defense_timer.should_wait() and not follow_node:
			var skill_2: Skill = skill_map[defense_skill]
			if ev.is_action_pressed("roll"):
				skill_2.pressed(self)
			elif ev.is_action_released("roll"):
				defense_timer.run(skill_2.cooldown * chaos_cooldown_reduction)
				skill_2.released(self)
				defense_sound.play()
				
		if not special_timer.should_wait():
			if ev.is_action_pressed("special_attack") and chaos_meter >= max_chaos_meter and not rolling_dice:
				self.chaos_meter = 0.0
				rolling_dice = true
				await chaos_roll.released(self)
				special_timer.run(chaos_roll.cooldown * chaos_cooldown_reduction)
				rolling_dice = false
	)
	
	GameManager.chaos_roll.connect(func(num):
		_roll_random_skills()
		_update_for_current_skills()
	)

func _roll_random_skills():
	var available := Skill.Type.values().filter(func(x): return x != attack_skill and x != defense_skill)
	attack_skill = available.pick_random()
	
	available.erase(attack_skill)
	defense_skill = available.pick_random()

func _update_for_current_skills(init = false):
	var attack = skill_map[attack_skill]
	attack_timer.wait_time = attack.cooldown
	attack_skill_slot.texture = attack.icon
	attack_sound.stream = attack.sound
	attack_timer.stop()
	
	var defense = skill_map[defense_skill]
	defense_timer.wait_time = defense.cooldown
	defense_skill_slot.texture = defense.icon
	defense_sound.stream = defense.sound
	defense_timer.stop()
	
	if init:
		var special = chaos_roll
		special_timer.wait_time = special.cooldown
		special_skill_slot.texture = special.icon

func add_to_hand(node: Node2D):
	hand_root.add_child(node)

func get_motion():
	var motion = Vector2(
		player_input.get_action_strength("move_right") - player_input.get_action_strength("move_left"),
		player_input.get_action_strength("move_down") - player_input.get_action_strength("move_up"),
	)
	return motion.normalized()

func _physics_process(delta):
	if follow_node:
		global_position = follow_node.global_position
	else:
		var motion = get_motion()
		var aim_dir = global_position.direction_to(get_global_mouse_position())
		body.scale.x = -1 if aim_dir.x < 0 else 1
		hand_root.global_rotation = Vector2.RIGHT.angle_to(aim_dir)
		
		animation_player.play("idle" if motion.length() == 0 else "move")
		
		velocity = velocity.move_toward(motion * speed, accel * delta)
		move_and_slide()

func _on_health_zero_health():
	died.emit()
	lose_sound.play()
	gameover.show()

func follow(node: Node2D):
	follow_node = node
	collision_shape_2d.disabled = true

func unfollow():
	follow_node = null

func invincible(time := 0.5):
	collision_shape_2d.disabled = true
	await get_tree().create_timer(time).timeout
	collision_shape_2d.disabled = false
	
