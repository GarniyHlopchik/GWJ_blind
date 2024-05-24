extends Node2D
class_name SoundPoint

var target_point: Vector2;
var speed: float = 500;
var start_point;
@onready var parent: SoundLine = $".."

func _ready() -> void:
	start_point = global_position;
		
var played = false;
func _physics_process(delta: float) -> void:
	if(global_position == target_point): return;
	var move_distance = speed * delta
	var distance = global_position.distance_to(target_point)
	if(move_distance > distance): 
		move_distance = distance;
	global_position = global_position.move_toward(target_point, move_distance);

