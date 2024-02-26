extends Area2D

@export var player: Player

@export var multipler_for_enemies := 0.001
@export var multipler_for_hits := 0.05
@export var add_to_chaos_meter_speed := 0.01
@export var chaos_reduce_amount := 0.02
@export var max_hits := 20

@onready var timer = $Timer

var hits_within_timeframe := 0.0
var add_to_chaos_meter := 0.0

func _ready():
	GameManager.chaos_roll.connect(func(_x): add_to_chaos_meter = 0)
	GameManager.hit.connect(func():
		if timer.is_stopped():
			timer.start()
		hits_within_timeframe += 1
	)
	timer.timeout.connect(func():
		var hits = min(hits_within_timeframe, max_hits)
		add_to_chaos_meter += hits * hits * multipler_for_hits
		hits_within_timeframe = 0
	)

func _process(_d):
	var enemy_count = get_overlapping_areas().size()
	player.chaos_meter -= chaos_reduce_amount / clamp(enemy_count, 1, 50)
	player.enemy_count = enemy_count
	
	#add_to_chaos_meter += enemy_count * multipler_for_enemies
	
	if add_to_chaos_meter > 0:
		var part = add_to_chaos_meter * add_to_chaos_meter_speed
		if add_to_chaos_meter < 0.001:
			part = add_to_chaos_meter
		player.chaos_meter += part
		add_to_chaos_meter -= part
		
		#if player.chaos_meter >= player.max_chaos_meter:
			#add_to_chaos_meter = 0
