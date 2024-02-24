extends Node

@export var player: Player
@export var health: Health

@export var max_heal := 0.05

func get_heal_amount():
	var p = player.chaos_meter / player.max_chaos_meter
	return max_heal * p

func _process(delta):
	health.heal(get_heal_amount())
