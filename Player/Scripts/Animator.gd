extends AnimationPlayer

@export var step_paritcle: SoundVisual;
@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var blade: Blade = $"../blade"
@onready var sound_print: SoundPrint = $"../Sprite2D/Area2D"

var prev_direction: bool;

enum State {IDLE, WALK, ATTACK, SIT, STAND_UP, PLAY_SITTING}
var state: State = State.IDLE;

var timer = null;
signal timeout;

func _process(delta: float) -> void:
	print(state)
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
	play(state_name);

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
	sprite_2d.modulate.a = 1
	state = State.SIT;

func _on_get_up() -> void:
	sprite_2d.modulate.a = 1
	state = State.STAND_UP;
func _on_play_note() -> void:
	state = State.PLAY_SITTING;
func _on_sat_down() -> void:
	timer = .3
	await timeout;
	state = State.PLAY_SITTING;
	sound_print.enabled = true;
func _on_got_up() -> void:
	timer = .3
	await timeout;
	state = State.IDLE;
	sound_print.enabled = true;
