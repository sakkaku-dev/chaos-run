class_name RateLimiter
extends Timer

@export var value: ValueProvider
@export var continuous := false

var original_time := wait_time

func _ready():
	if value:
		wait_time = value.get_value()
	
	one_shot = true
	if continuous:
		timeout.connect(func(): run())

func should_wait():
	return not is_stopped()

func run(time = wait_time):
	var v = time if value == null else value.get_value()
	start(v)
