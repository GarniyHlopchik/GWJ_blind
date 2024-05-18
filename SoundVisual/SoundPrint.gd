extends Area2D
class_name SoundPrint

@export var sprite: Sprite2D;
@export var lifetime_type: LifetimeType = LifetimeType.INSTANT
##Usles for lifetime_type = FROM_WAVE
@export var fading_time: float = 0.5

enum LifetimeType {INSTANT, FROM_WAVE}

var enabled = true;

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
		
	match lifetime_type:
		LifetimeType.INSTANT:
			if(parent.default_color.a > line.default_color.a):
				line = parent
		LifetimeType.FROM_WAVE:
			var current_procent = line.lifetime / line.sound.lifetime
			var parent_procent = parent.lifetime / parent.sound.lifetime
			#print("%s > %s = %s" % [line.lifetime, parent.lifetime, line.lifetime > parent.lifetime])
			if(parent_procent < current_procent):
				line = parent

var fading: float = 0;

func _process(delta: float) -> void:
	if(!enabled): return;
	match lifetime_type:
		LifetimeType.INSTANT:
			var areas = get_overlapping_areas()
			if(areas.size() > 0 && is_instance_valid(line)):
				sprite.modulate.a = 1 * line.default_color.a;
				fading = 0;
			else:
				if(fading < fading_time && is_instance_valid(line)):
					fading += delta;
					fading = clamp(fading, 0, fading_time);
					sprite.modulate.a = (1 - fading / fading_time) * line.default_color.a;
				else:
					sprite.modulate.a = 0;
					line = null;
		LifetimeType.FROM_WAVE:
			if(is_instance_valid(line)):
				sprite.modulate.a = line.default_color.a
			else:
				sprite.modulate.a = 0
	#print("[%s]: %s" % [$"../..".name, sprite.modulate.a]);
