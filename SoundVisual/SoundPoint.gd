extends Node2D
class_name SoundPoint

var target_point: Vector2;
var speed: float = 500;
var start_point;
var is_finish = false;
var is_reversed = false;

func _ready() -> void:
	start_point = global_position;
	
func _process(delta: float) -> void:
	is_finish = target_point == global_position;
	if(is_finish): return;
	var move_distance = speed * delta
	var distance = global_position.distance_to(target_point)
	global_position = global_position.move_toward(target_point, 
		move_distance if move_distance < distance else distance)

func reverse():
	target_point = start_point;
	start_point = global_position;
	is_reversed = true;
