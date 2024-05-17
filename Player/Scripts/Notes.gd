extends Node2D

@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var sit_timer: SitTimer = $"../sit_timer"
@export var notes_audio: Array[SoundVisual];
@export var correct_pattern_audio: SoundVisual;

const pattern: Array[int] = [5,5,7,5,6,7,6,5,4,1,5,6,7,6,5,5,5,8,5,7,6,5,4,5,1,5,6,7,6,5,3]

var pattern_index: int = 0;

func _process(delta: float) -> void:
	if(!sit_timer.is_sit):
		return;
	if(!Input.is_action_just_pressed("Any_note")):
		return;
	for i in notes_audio.size():
		if(Input.is_action_just_pressed("Note_%s" % (i+1))):
			sound_emiter.emit_wave(notes_audio[i]);
			if(i+1 == pattern[pattern_index]):
				pattern_index+=1;
				print(pattern_index);
			else:
				print("[%s] error: intended %s, clicked %s" % [pattern_index, pattern[pattern_index], i+1]);
				pattern_index = 0;
			if(pattern_index == pattern.size()):
				pattern_index = 0;
				sound_emiter.emit_wave(correct_pattern_audio);
