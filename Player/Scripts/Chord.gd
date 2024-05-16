extends Timer

@export var chord_particle: SoundVisual;
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
var chord_ready = true;

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Play") && chord_ready):
		sound_emiter.emit_wave(chord_particle);
		start();
		chord_ready = false;
		await timeout
		chord_ready = true;
