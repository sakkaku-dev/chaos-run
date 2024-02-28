extends Control

@export var restart: BaseButton

func _ready():
	restart.pressed.connect(func():
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	visibility_changed.connect(func():
		get_tree().paused = visible
	)
