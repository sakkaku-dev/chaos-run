extends DirectionalSkill

@export var attack_scene: PackedScene

func released(p: Player):
	var attack = attack_scene.instantiate()
	get_tree().current_scene.add_child(attack)
	attack.global_position = p.global_position
	attack.dive_to(get_dir(p))
	p.follow(attack)
	await attack.attack_finish
	p.unfollow()
