extends AnimationPlayer

@export var step_paritcle: SoundVisual;
@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter
@onready var blade: Blade = $"../blade"

var prev_direction: bool;

enum State {IDLE, WALK, ATTACK}
var state: State = State.IDLE;

func _process(delta: float) -> void:
	var state_name = State.keys()[state].to_lower();
	#print(state_name)
	call("_%s" % state_name, delta);
	current_animation = state_name
	play(state_name);
	
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
