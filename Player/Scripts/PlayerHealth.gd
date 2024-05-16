extends HealthComponent

func _take_damage(attack_info: AttackInfo):
	super._take_damage(attack_info);
	PlayerState.hp = hp;
