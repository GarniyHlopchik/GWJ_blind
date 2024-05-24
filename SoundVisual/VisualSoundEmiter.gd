extends Node2D
class_name VisualSoundEmiter

@export var ray_cast_point_amount: int = 50;

func _ready() -> void:
	var angle = PI * 2 / ray_cast_point_amount;
	var current_angle = deg_to_rad(180);
	for i in ray_cast_point_amount:
		var ray = RayCast2D.new()
		ray.collision_mask = 1;
		ray.target_position = Vector2(
			sin(current_angle), 
			cos(current_angle)
		) * 3000
		current_angle += angle
		add_child(ray);

func emit_wave(sound: SoundVisual):
	var line = SoundLine.new()
	line.global_position = global_position;
	line.rays = get_children() as Array[RayCast2D];
	line.sound = sound
	line.embeddedness = sound.embeddedness-1;
	get_viewport().add_child(line);
