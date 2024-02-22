extends DirectionalSkill

@export var teleport_distance := 100
@export var rect: ColorRect

var is_pressed = false
var player: Player

func _ready():
	rect.hide()

#func pressed(p: Player):
	#is_pressed = true
	#player = p

func released(player: Player):
	player.global_position += get_dir(player) * teleport_distance
	is_pressed = false

#func _process(delta):
	#if not is_pressed:
		#rect.hide()
		#return
	#
	#rect.show()
	#rect.global_position = player.global_position + get_dir(player) * teleport_distance
