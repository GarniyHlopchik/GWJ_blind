extends CharacterBody2D
class_name Player 

@export var acceleration_time: float
@export var speed = 150.0

var direction: Vector2;

func _process(delta: float) -> void:
	PlayerState.position = global_position;

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	#print("%s %s" % [direction, direction.length()]);
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	move_and_slide()
