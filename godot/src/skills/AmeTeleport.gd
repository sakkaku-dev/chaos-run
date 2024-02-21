extends Skill

@export var teleport_distance := 100
@export var rect: ColorRect

var is_pressed = false
var player: Player

func _ready():
	rect.hide()

func pressed(p: Player):
	is_pressed = true
	player = p

func released(player: Player):
	player.global_position += _get_dir()
	is_pressed = false

func _get_dir():
	var motion = player.get_motion()
	var dir = motion if motion else player.global_position.direction_to(player.get_global_mouse_position())
	return dir * teleport_distance

func _process(delta):
	if not is_pressed:
		rect.hide()
		return
	
	rect.show()
	rect.global_position = player.global_position + _get_dir()
