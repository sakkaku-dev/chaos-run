extends HitBox

func _ready():
	super._ready()
	attack()
	attack_finish.connect(func(): queue_free())
