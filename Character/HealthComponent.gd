extends Area2D
class_name HealthComponent

@export var hp: int = 100;
@export var max_hp: int = 100;
signal on_death;
signal on_take_damage(attack_info);

@onready var sound_emiter: VisualSoundEmiter = %sound_emiter


func _ready() -> void:
	if(!is_instance_valid(sound_emiter)):
		printerr("\"sound_emiter\" component is mising in this scene")
	hp = max_hp;
	on_take_damage.connect(_take_damage)
	on_take_damage.connect(func (i: AttackInfo): 
		print("[%s]: take %s damage" % [get_parent().name, i.damage])
	);
	on_death.connect(func (i: AttackInfo): 
		print("[%s]: dead" % get_parent().name)
	);

func deal_damage(attack_info: AttackInfo):
	if(!attack_info): return;
	on_take_damage.emit(attack_info);
	
func _take_damage(attack_info: AttackInfo):
	hp -= attack_info.damage;
	if(hp < 0):
		on_death.emit();
