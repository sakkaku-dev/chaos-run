class_name TeleportEffect
extends AnimatedSprite2D

@export var remove_on_finish := true

func _ready():
	if remove_on_finish:
		start()
		animation_finished.connect(func(): queue_free())
	else:
		hide()
		animation_finished.connect(func(): hide())

func start():
	frame = 0
	play("default")
	show()
