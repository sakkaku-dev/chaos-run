class_name Player
extends CharacterBody2D

signal died()
signal chaos_meter_changed(value, max_value)

@export var accel := 800
@export var speed := 100
@export var roll_speed := 300

@export var max_chaos_meter := 100

@export var gameover: Control
@export var chaos_meter_bar: ProgressBar

@export var special_skill_slot: TextureRect
@export var attack_skill_slot: TextureRect
@export var defense_skill_slot: TextureRect

@onready var attack_timer = $AttackTimer
@onready var defense_timer = $DefenseTimer

@onready var player_input = $PlayerInput
@onready var animation_player = $AnimationPlayer
@onready var body = $Body
@onready var hand_root = $HandRoot

@onready var chaos_meter := 0.0:
	set(v):
		chaos_meter = clamp(v, 0, max_chaos_meter)
		chaos_meter_changed.emit(v, max_chaos_meter)
		chaos_meter_bar.value = v
		chaos_meter_bar.max_value = max_chaos_meter
		
		special_skill_slot.modulate = Color(.5, .5, .5, .8) if chaos_meter < max_chaos_meter else Color.WHITE

@onready var skill_map := {
	Skill.Type.AME_TELEPORT: $Skills/AmeTeleport,
	Skill.Type.KIARA_SWORD_SHIELD: $Skills/KiaraAttack,
	Skill.Type.CALLI_SCYTHE: $Skills/CalliScythe,
	Skill.Type.GURA_SHARK_DIVE: $Skills/GuraDive,
	Skill.Type.INA_TENTACLES: $Skills/InaTentacles,
}

var attack_skill: Skill.Type = Skill.Type.CALLI_SCYTHE
var defense_skill: Skill.Type = Skill.Type.INA_TENTACLES

func _ready():
	animation_player.play("RESET")
	_update_for_current_skills()
	
	player_input.on_event.connect(func(ev: InputEvent):
		if not attack_timer.should_wait():
			if ev.is_action_pressed("attack"):
				skill_map[attack_skill].pressed(self)
			elif ev.is_action_released("attack"):
				attack_timer.run()
				skill_map[attack_skill].released(self)
		
		if not defense_timer.should_wait():
			if ev.is_action_pressed("roll"):
				skill_map[defense_skill].pressed(self)
			elif ev.is_action_released("roll"):
				defense_timer.run()
				skill_map[defense_skill].released(self)
				
		if ev.is_action_pressed("special_attack") and chaos_meter >= max_chaos_meter:
			pass
			#special_hitbox.attack()
	)

func _update_for_current_skills():
	var attack = skill_map[attack_skill]
	attack_timer.wait_time = attack.cooldown
	attack_skill_slot.texture = attack.icon
	
	var defense = skill_map[defense_skill]
	defense_timer.wait_time = defense.cooldown
	defense_skill_slot.texture = defense.icon

func add_to_hand(node: Node2D):
	hand_root.add_child(node)

func get_motion():
	var motion = Vector2(
		player_input.get_action_strength("move_right") - player_input.get_action_strength("move_left"),
		player_input.get_action_strength("move_down") - player_input.get_action_strength("move_up"),
	)
	return motion.normalized()

func _physics_process(delta):
	var motion = get_motion()
	var aim_dir = global_position.direction_to(get_global_mouse_position())
	body.scale.x = -1 if aim_dir.x < 0 else 1
	hand_root.global_rotation = Vector2.RIGHT.angle_to(aim_dir)
	
	animation_player.play("idle" if motion.length() == 0 else "move")
	
	velocity = velocity.move_toward(motion * speed, accel * delta)
	move_and_slide()

func _on_health_zero_health():
	died.emit()
	gameover.show()

