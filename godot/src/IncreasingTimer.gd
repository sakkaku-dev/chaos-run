class_name IncreasingTimer
extends Timer

@export var min_time := 0.1
@export var max_time := 1.0
@export var increase_value := 0.99
@onready var current_time := wait_time

func _ready():
	one_shot = true
	
	timeout.connect(func():
		current_time = clamp(current_time * increase_value, min_time, max_time)
		start(current_time)
	)
