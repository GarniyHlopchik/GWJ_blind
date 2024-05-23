extends AnimationPlayer

@export var step_paritcle: SoundVisual;
@export var sit_sound: AudioStream;
@export var stand_up_sound: AudioStream;

@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var blade: Blade = $"../blade"
@onready var sound_print: SoundPrint = $"../Sprite2D/Area2D"
@onready var audio_stream: AudioStreamPlayer = $AudioStream

var prev_direction: bool;

enum State {IDLE, WALK, ATTACK, SIT, STAND_UP, PLAY_SITTING, KNOCKED, PLAY_STANDING, DEATH}
var state: State = State.IDLE;

var timer = null;
signal timeout;

func _process(delta: float) -> void:
	if(state == State.DEATH):
		_death(delta);
		return;
	if(timer):
		if(timer > 0):
			sprite_2d.self_modulate.a = timer / .3;
			timer-=delta;
		else:
			sprite_2d.self_modulate.a = 1;
			timer = null;
			timeout.emit()
		return;
		
	var state_name = State.keys()[state].to_lower();
	#print(state_name)
	call("_%s" % state_name, delta);
	current_animation = state_name
	if(state != State.SIT && state != State.STAND_UP):
		play(state_name);


func _knocked(delta: float):
	sprite_2d.flip_h = prev_direction;
	if(player.knocked_velocity == Vector2.ZERO):
		state = State.IDLE
		
func _death(delta: float):
	sprite_2d.flip_h = prev_direction;
	sound_print.enabled = false;
	sprite_2d.self_modulate.a = 1;
	sprite_2d.modulate.a = 1
	
func _death_finished(delta: float):
	death_animation_finishied.emit()
signal death_animation_finishied;

func _play_standing(delta: float):
	sprite_2d.flip_h = prev_direction;
	await animation_finished;
	state = State.WALK

func _sit(delta: float):
	sprite_2d.flip_h = prev_direction;
	sound_print.enabled = false;
func _stand_up(delta: float):
	sprite_2d.flip_h = prev_direction;
	sound_print.enabled = false;
func _play_sitting(delta: float):
	sprite_2d.flip_h = prev_direction;
	sound_print.enabled = true;
func _idle(delta: float):
	sprite_2d.flip_h = prev_direction;
	if(player.direction != Vector2.ZERO):
		state = State.WALK;
		_process(delta);
func _walk(delta: float):
	if(player.direction == Vector2.ZERO):
		state = State.IDLE
		_process(delta);
		return;
	if(player.direction.x != 0):
		sprite_2d.flip_h = player.direction.x < 0
		prev_direction = sprite_2d.flip_h
	else:
		sprite_2d.flip_h = prev_direction;
		
func _attack(delta: float):
	sprite_2d.flip_h = blade.attac_dir.x < 0;
	pass

func step() -> void:
	sound_emiter.emit_wave(step_paritcle);

func _handle_attack_started() -> void:
	state = State.ATTACK;

func _handle_attack_ended() -> void:
	state = State.IDLE;

func _on_sit() -> void:
	sound_print.enabled = false;
	sprite_2d.modulate.a = 1
	state = State.SIT;
	play("sit");
	audio_stream.stream = sit_sound;
	audio_stream.play()
	
func _on_get_up() -> void:
	sprite_2d.modulate.a = 1
	state = State.STAND_UP;
	play("stand_up");
	audio_stream.stream = stand_up_sound;
	audio_stream.play()
func _on_play_note() -> void:
	if(state != State.SIT || State.STAND_UP):
		state = State.PLAY_SITTING;
func _on_sat_down() -> void:
	pause()
	timer = .3
	await timeout;
	play("play_sitting");
	state = State.PLAY_SITTING;
	sound_print.enabled = true;
func _on_got_up() -> void:
	pause()
	timer = .3
	await timeout;
	play("idle");
	state = State.IDLE;
	sound_print.enabled = true;


func _on_death() -> void:
	state = State.DEATH;
	play("death");
	if(!animation_finished.is_connected(_death_finished)):
		animation_finished.connect(_death_finished);


func _on_knocked(attack_info: Variant) -> void:
	state = State.KNOCKED;


func _on_play_chord() -> void:
	if(state != State.PLAY_SITTING):
		state = State.PLAY_STANDING;
