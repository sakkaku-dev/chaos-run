class_name Health
extends Node

signal health_changed(hp)
signal zero_health()

@export var max_health_value: ValueProvider
@export var max_health := 1
@onready var health := max_health : set = _set_health

@export var hp_bar: ProgressBar

func _ready():
	if hp_bar:
		hp_bar.max_value = max_health
		hp_bar.value = health

func hurt(dmg: int):
	self.health -= dmg

func heal(amount: int):
	self.health += amount

func _get_max_health():
	return max_health_value.get_value() if max_health_value else max_health

func _set_health(v: int):
	health = clamp(v, 0, max_health) 
	health_changed.emit(health)
	
	if hp_bar:
		hp_bar.value = v

	if is_dead():
		zero_health.emit()

func is_full_health():
	return health == max_health

func is_dead():
	return health <= 0

func get_health_percent():
	return float(health) / float(max_health)
