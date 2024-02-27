extends Skill

@export var dice_roll: DiceRoll

func released(p: Player):
	await dice_roll.roll()
