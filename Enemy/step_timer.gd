extends Timer

@export var step_sound: SoundVisual;
@onready var sound_emiter: VisualSoundEmiter = $"../sound_emiter"
@onready var enemy: Enemy = $".."

func _ready() -> void:
	timeout.connect(step)

func step():
	if(enemy.is_moving && PlayerState.is_sit):
		sound_emiter.emit_wave(step_sound);
