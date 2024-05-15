extends AnimationPlayer

@export var step_paritcle: SoundVisual;
@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sound_emiter: VisualSoundEmiter = $"../sound_emiter"

var prev_direction: bool;

func _process(delta: float) -> void:
	if(player.direction.x != 0):
		sprite_2d.flip_h = player.direction.x < 0
		prev_direction = sprite_2d.flip_h
	else:
		sprite_2d.flip_h = prev_direction;
	if(player.direction.length() > 0 && !is_playing()):
		play();
	elif(player.direction.length() == 0 && is_playing()):
		stop();

func step() -> void:
	sound_emiter.emit_wave(step_paritcle);
