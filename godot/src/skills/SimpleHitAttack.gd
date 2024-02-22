extends Skill

@export var attack_scene: PackedScene
@export var hitbox_resource: HitBoxAttackResource

func released(p: Player):
	var attack = attack_scene.instantiate()
	p.add_to_hand(attack)
	attack.apply(hitbox_resource)
