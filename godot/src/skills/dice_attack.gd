extends Node2D

var time := 0.0

func _process(delta):
	time += delta
	
	if time >= 0.2:
		queue_free()


func _on_hit_box_hit():
	queue_free()
