extends Skill

@export var teleport_distance := 100

func execute(player: Player):
	var dir = player.global_position.direction_to(player.get_global_mouse_position())
	player.global_position += dir * teleport_distance
