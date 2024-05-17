extends AnimationPlayer

@onready var blade: Blade = $".."
@onready var smear: Sprite2D = $"../smear"

func _process(delta: float) -> void:
	var left = blade.attac_dir.x < 0
	smear.flip_v = left
	smear.position.y = 6 * (1 if left else -1)
	blade.position.x = 10 * (1 if left else -1)
	#print(blade.position.x)

func _handle_attack_started() -> void:
	play("default");


func _handle_attack_ended() -> void:
	stop();
