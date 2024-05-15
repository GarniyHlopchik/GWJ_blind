extends AnimationPlayer

@export var step_paritcle: SoundVisual;
@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sound_emiter: VisualSoundEmiter = $"../sound_emiter"

func _process(delta: float) -> void:
	sprite_2d.flip_h = player.direction.x < 0
	if(player.direction.length() > 0 && !is_playing()):
		play();
	elif(player.direction.length() == 0 && is_playing()):
		stop();

func step() -> void:
	sound_emiter.emit_wave(step_paritcle);
