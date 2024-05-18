extends Node2D

@export var sound_step_distance: float = 80;
@export var sound: SoundVisual;

@onready var sound_emiter: VisualSoundEmiter = %sound_emiter

var prev_position: Vector2;
var distance: float = 0

func _ready() -> void:
	global_position = get_global_mouse_position();
	prev_position = global_position;

func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
	distance += global_position.distance_to(prev_position)
	if(distance >= sound_step_distance):
		distance = 0;
		sound_emiter.emit_wave(sound);
	prev_position = global_position;
