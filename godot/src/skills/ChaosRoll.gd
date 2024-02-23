extends Skill

@export var dice_scene: PackedScene

func released(p: Player):
	var dice = dice_scene.instantiate()
	get_tree().current_scene.add_child(dice)
	dice.global_position = p.global_position
