extends AudioStreamPlayer

@export var off = -27;
@export var normal = 0;
@export var change_speed = 10;

@onready var sit_timer: SitTimer = $"../sit_timer"

func _process(delta: float) -> void:
	if(sit_timer.is_sit && volume_db > off):
		volume_db -= change_speed * delta;
	if(!sit_timer.is_sit && volume_db < normal):
		volume_db += change_speed * delta;
