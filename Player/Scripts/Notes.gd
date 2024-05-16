extends Node2D

@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var sit_timer: SitTimer = $"../sit_timer"
@export var notes_audio: Array[SoundVisual];

func _process(delta: float) -> void:
	if(!sit_timer.is_sit):
		return;
	if(!Input.is_action_just_pressed("Any_note")):
		return;
	for i in notes_audio.size():
		if(Input.is_action_just_pressed("Note_%s" % (i+1))):
			sound_emiter.emit_wave(notes_audio[i]);
			print(notes_audio[i].audio[0].resource_path.get_basename());
