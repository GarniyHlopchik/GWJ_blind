extends Node2D
class_name SoundPoint

var target_point: Vector2;
var speed: float = 500;
var start_point;
var fade = false;

func _ready() -> void:
	start_point = global_position;
	if start_point.distance_to(target_point) > 1000:
		fade = true;
	
func _process(delta: float) -> void:
	var move_distance = speed * delta
	var distance = global_position.distance_to(target_point)
	global_position = global_position.move_toward(target_point, 
		move_distance if move_distance < distance else distance);

func percent_to_finish():
	return global_position.distance_to(target_point) / start_point.distance_to(target_point);
