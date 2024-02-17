extends ProgressBar

@export var health: Health

var tw: Tween

func _ready():
	if health:
		max_value = health.max_health
		value = health.max_health
		modulate = Color.TRANSPARENT
		
		health.health_changed.connect(func(hp):
			value = hp
			_toggle_visibility(hp < health.max_health)
		)

func _toggle_visibility(show = false):
	if tw and tw.is_running():
		tw.kill()
	
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.WHITE if show else Color.TRANSPARENT, 0.5)
