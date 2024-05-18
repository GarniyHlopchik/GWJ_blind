extends Panel

@export var fading_time: float = 0.5
signal button_click;
@onready var area: Area2D = $Area2D

var line: SoundLine
var style_box

func input(event: InputEvent):
	if 	event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		event.is_released():
			button_click.emit();

func _ready() -> void:
	gui_input.connect(input)
	style_box = get_theme_stylebox("panel");

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
		style_box.border_color.a = 1 * line.default_color.a;
		fading = 0;
	else:
		if(fading < fading_time && is_instance_valid(line)):
			fading += delta;
			fading = clamp(fading, 0, fading_time);
			style_box.border_color.a = (1 - fading / fading_time) * line.default_color.a;
		else:
			style_box.border_color.a = 0;
			line = null;
