extends Skill

@export var attack_scene: PackedScene

func pressed(p: Player):
	var attack = attack_scene.instantiate()
	p.add_to_hand(attack)
