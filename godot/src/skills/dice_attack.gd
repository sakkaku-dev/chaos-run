extends Node2D

var time := 0.0
var hit := false

@onready var impact = $Impact
@onready var collision_shape_2d = $HitBox/CollisionShape2D

func _process(delta):
	time += delta

	if not hit:
		hit = true
		impact.play()
	
	if time >= 0.2:
		_free()

func _on_hit_box_hit():
	impact.play()
	_free()
	
func _free():
	if impact.playing:
		collision_shape_2d.set_deferred("disabled", true)
		hide()
		await impact.finished
	queue_free()
