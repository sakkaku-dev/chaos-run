extends Node2D

@export var roll_time := 2.0
@export var hold_num_time := 1.0

@onready var dice = $Dice
@onready var dice_number = $DiceNumber
@onready var dice_roll = $DiceRoll

func _ready():
	dice.play("roll")
	dice_roll.play()
	dice_number.hide()
	await get_tree().create_timer(roll_time).timeout
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(dice_roll, "volume_db", -30, 0.5)
	
	var num = randi_range(1, 6)
	dice_number.frame = num - 1
	dice_number.show()
	dice.play("default")
	
	GameManager.chaos_roll.emit(num)

	await get_tree().create_timer(hold_num_time).timeout
	queue_free()
