extends Skill

@export var teleport_distance := 100

func pressed(player: Player):
	pass # TODO: show teleport position

func released(player: Player):
	var motion = player.get_motion()
	var dir = motion if motion else player.global_position.direction_to(player.get_global_mouse_position())
	player.global_position += dir * teleport_distance
