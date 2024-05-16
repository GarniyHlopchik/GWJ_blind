extends Area2D
var can_attack = true
@export var attack_info: AttackInfo;
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Attack") and can_attack:
		can_attack = false
		$attack_cooldown.start()
		$attack_duration.start()
		$smear.show()
		$hit_area.disabled = false

		

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_attack_duration_timeout() -> void:
	$smear.hide()
	$hit_area.disabled = true

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		var health = area as HealthComponent;
		var info: AttackInfo = attack_info.duplicate();
		info.knockback_dir = transform.x;
		health.deal_damage(info)
