extends Area2D
var can_attack = true

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


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(50,transform.x)