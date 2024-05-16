extends Resource
class_name AttackInfo;

@export var damage: int = 30;
@export var knockback_strength: float = 2;
@export var knockback_time: float = 0.5;
@export var sound_visual: SoundVisual;
var knockback_dir: Vector2;
