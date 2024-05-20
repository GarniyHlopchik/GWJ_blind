extends Area2D
class_name Blade

signal on_attack_started;
signal on_attack_ended;
var is_attacking: bool = false;
var attac_dir: Vector2
var can_attack = true
@export var attack_info: AttackInfo;
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var player: Player = $".."

@export var sword_slash: SoundVisual

func _process(delta: float) -> void:
	attac_dir = global_position.direction_to(get_global_mouse_position())
	look_at(get_global_mouse_position())
	
func _input(event: InputEvent) -> void:
	if(!player.can_move): return;
	if Input.is_action_just_pressed("Attack") and can_attack:
		sound_emiter.emit_wave(sword_slash);
		on_attack_started.emit();
		can_attack = false
		is_attacking = true;
		$attack_cooldown.start()
		$attack_duration.start()
		$smear.show()
		$hit_area.disabled = false
		

		

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _end_attack() -> void:
	$smear.hide()
	$hit_area.disabled = true
	is_attacking = false;
	on_attack_ended.emit();

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		sound_emiter.emit_wave(attack_info.sound_visual);
		var health = area as HealthComponent;
		var info: AttackInfo = attack_info.duplicate();
		info.knockback_dir = transform.x;
		health.deal_damage(info)
