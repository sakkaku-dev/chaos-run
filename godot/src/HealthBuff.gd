extends TextureRect

@export var heal: ProgressiveHeal
@export var level_1_icon: Control
@export var level_2_icon: Control

func _process(delta):
	var chaos = heal.player.chaos_meter / heal.player.max_chaos_meter
	visible = chaos > 0
	level_1_icon.visible = chaos > 0.5
	level_2_icon.visible = chaos > 0.8
