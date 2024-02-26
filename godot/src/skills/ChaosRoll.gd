extends Skill

@export var dice_scene: PackedScene
@export var dice_slot: Control

func released(p: Player):
	var dice = dice_scene.instantiate()
	dice_slot.add_child(dice)
	await GameManager.chaos_roll
