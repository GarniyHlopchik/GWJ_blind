extends CharacterBody2D

@export var acceleration_time: float

@export var speed = 150.0
@export var chord_particle: SoundVisual;
@export var step_paritcle: SoundVisual;
@export var note_wave: SoundVisual;
@export var notes_audio: Array[AudioStream];
@onready var step_timer: Timer = $step_timer
@onready var chord_cooldown: Timer = $chord_cooldown
@onready var sound_emiter: VisualSoundEmiter = $sound_emiter


var direction
var chord_ready = true;

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Play") && chord_ready):
		sound_emiter.emit_wave(chord_particle);
		chord_cooldown.start();
		chord_ready = false;
	if(Input.is_action_just_pressed("Any_note")):
		for i in notes_audio.size():
			if(Input.is_action_just_pressed("Note_%s" % (i+1))):
				var note = note_wave.duplicate() as SoundVisual;
				note.audio.append(notes_audio[i]);777
				sound_emiter.emit_wave(note);

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	if(direction && step_timer.is_stopped()):
		step_timer.start();
	elif(!direction && !step_timer.is_stopped()):
		step_timer.stop();
	move_and_slide()
	

func _on_chord_cooldown_timeout() -> void:
	chord_ready = true;

func _on_step_timer_timeout() -> void:
	sound_emiter.emit_wave(step_paritcle);

