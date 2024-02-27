extends Skill

@export var attack_scene: PackedScene
@export var hitbox_resource: HitBoxAttackResource
@export var to_hand := true

func released(p: Player):
	var attack = attack_scene.instantiate()
	if to_hand:
		p.add_to_hand(attack)
	else:
		p.add_child(attack)
		
	await attack.apply(hitbox_resource)
	attack.attack()
