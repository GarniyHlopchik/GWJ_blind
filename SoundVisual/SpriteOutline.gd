extends Area2D

@export var sprite: Sprite2D;

func _ready() -> void:
	if(!sprite):
		if ($".." is Sprite2D):
			sprite = $".."
		else:
			printerr("Sprite is not set");
			return
	
	area_entered.connect(_sound_entered);

var line: SoundLine

func _sound_entered(area: Area2D):
	var parent = area.get_parent() as SoundLine;
	if(!line): 
		line = parent
		return;
	var current_procent = line.lifetime
	var parent_procent = parent.lifetime
	print("%s > %s = %s" % [parent_procent, current_procent, parent_procent > current_procent])
	if(line.lifetime > parent.lifetime):
		line = parent
	
func _process(delta: float) -> void:
	if(is_instance_valid(line)):
		sprite.modulate.a = line.default_color.a
	else:
		sprite.modulate.a = 0
