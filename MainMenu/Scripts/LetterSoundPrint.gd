extends Label

@export var fading_time: float = 0.5
@onready var area: Area2D = $Area2D

var line: SoundLine

func _ready() -> void:
	label_settings.font_color.a = 0;

func _sound_entered(area: Area2D):
	var parent = area.get_parent() as SoundLine;
	if(!line): 
		line = parent
		return;
	if(parent.default_color.a > line.default_color.a):
		line = parent
var fading: float = 0;

func _process(delta: float) -> void:
	var areas = area.get_overlapping_areas()
	if(areas.size() > 0 && is_instance_valid(line)):
		label_settings.font_color.a = 1 * line.default_color.a;
		fading = 0;
	else:
		if(fading < fading_time && is_instance_valid(line)):
			fading += delta;
			fading = clamp(fading, 0, fading_time);
			label_settings.font_color.a = (1 - fading / fading_time) * line.default_color.a;
		else:
			label_settings.font_color.a = 0;
			line = null;
