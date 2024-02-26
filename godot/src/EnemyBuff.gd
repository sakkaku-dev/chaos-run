extends TextureRect

@export var player: Player
@export var property := ""
@export var max_property := ""

@export var level_0_limit := 0.0
@export var level_0_text := ""

@export var level_1_icon: Control
@export var level_1_limit := 0.0
@export var level_1_text := ""

@export var level_2_icon: Control
@export var level_2_limit := 0.0
@export var level_2_text := ""

func _process(delta):
	var value = _get_value()
	
	visible = value > level_0_limit
	level_1_icon.visible = value > level_1_limit
	level_2_icon.visible = value > level_2_limit
	
	tooltip_text = _get_tooltip_text(value)
	
func _get_tooltip_text(value: float):
	if value > level_2_limit:
		return level_2_text
	if value > level_1_limit:
		return level_1_text

	return level_0_text

func _get_value():
	var value = player.get(property)
	
	if max_property:
		var max = player.get(max_property)
		if max:
			return value / max
	
	return value
