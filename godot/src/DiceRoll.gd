class_name DiceRoll
extends AnimatedSprite2D

@export var roll_time := 2.0

@onready var dice_number = $DiceNumber
@onready var dice_roll = $DiceRoll

func _ready():
	dice_number.hide()

func roll():
	play("roll")
	dice_roll.play()
	dice_number.hide()
	await get_tree().create_timer(roll_time).timeout

	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(dice_roll, "volume_db", -30, 0.5)
	
	var num = randi_range(1, 6)
	dice_number.frame = num - 1
	dice_number.show()
	play("idle")
	
	GameManager.chaos_roll.emit(num)
