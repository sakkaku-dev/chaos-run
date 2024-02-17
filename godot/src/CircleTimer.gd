extends ColorRect

@export var timer: Timer

func _ready():
	material = material.duplicate()
	
func _process(delta):
	if timer.is_stopped():
		hide()
		return
	
	show()
	var p = timer.time_left / timer.wait_time
	material.set_shader_parameter("fill_ratio", p)
