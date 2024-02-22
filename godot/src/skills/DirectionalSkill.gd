class_name DirectionalSkill
extends Skill

func get_dir(player: Player):
	var motion = player.get_motion()
	var dir = motion if motion else player.global_position.direction_to(player.get_global_mouse_position())
	return dir.normalized()
