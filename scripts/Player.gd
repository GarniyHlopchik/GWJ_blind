extends CharacterBody2D

@export var acceleration_time: float

@export var speed = 150.0
@export var chord_particle: SoundVisual;
@export var step_paritcle: SoundVisual;
@export var notes_audio: Array[SoundVisual];
@onready var step_timer: Timer = $step_timer
@onready var chord_cooldown: Timer = $chord_cooldown
@onready var sound_emiter: VisualSoundEmiter = $sound_emiter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


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
				sound_emiter.emit_wave(notes_audio[i]);
				print(notes_audio[i].audio[0].resource_path);
				print(i);

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	if(direction && !animation_player.is_playing()):
		animation_player.play();
		#step_timer.start();
	elif(!direction && animation_player.is_playing()):
		animation_player.stop();
		#step_timer.stop();
	sprite_2d.flip_h = direction.x < 0
	move_and_slide()
	

func _on_chord_cooldown_timeout() -> void:
	chord_ready = true;

func _on_step_timer_timeout() -> void:
	sound_emiter.emit_wave(step_paritcle);

