extends Area2D
class_name health_component

## БАТЬКО ЦЬОГО КЛАСУ ОБОВ'ЯЗКОВО ПОВИНЕН МАТИ ФУНКЦІЇ damage_reaction(knockback_dir: Vector2) І death() АБО ГРА ЗРОБИТЬ БУМ
@export var max_hp: int
@onready var hp = max_hp

func take_damage(damage,knockback):
	hp -= damage
	get_parent().damage_reaction(knockback)
	if hp <= 0:
		get_parent().death()
