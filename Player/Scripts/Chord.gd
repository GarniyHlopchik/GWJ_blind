extends Timer

@export var chord_particle: SoundVisual;
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
var chord_ready = true;

signal play_chord;

func _unhandled_input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Play") && chord_ready):
		play_chord.emit();
		sound_emiter.emit_wave(chord_particle);
		start();
		chord_ready = false;
		await timeout
		chord_ready = true;
