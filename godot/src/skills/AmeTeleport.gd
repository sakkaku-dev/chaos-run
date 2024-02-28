extends DirectionalSkill

@export var teleport_distance := 100
@export var rect: ColorRect
@export var teleport_effect: PackedScene
@export var player_effect: TeleportEffect

var is_pressed = false
var player: Player

func _ready():
	rect.hide()

func pressed(p: Player):
	is_pressed = true
	player = p

func released(player: Player):
	var eff = teleport_effect.instantiate()
	get_tree().current_scene.add_child(eff)
	eff.global_position = player.global_position
	
	player_effect.start()
	player.global_position += get_dir(player) * teleport_distance
	is_pressed = false
	player.invincible()

func _process(delta):
	if not is_pressed:
		rect.hide()
		return
	
	rect.show()
	rect.global_position = player.global_position + get_dir(player) * teleport_distance
