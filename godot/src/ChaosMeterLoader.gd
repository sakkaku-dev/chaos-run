extends Area2D

@export var max_enemies_for_chaos := 30.0
@export var player: Player

func _process(_d):
	var enemy_count = get_overlapping_areas().size()
	player.chaos_meter = (float(enemy_count) / max_enemies_for_chaos) * 100
