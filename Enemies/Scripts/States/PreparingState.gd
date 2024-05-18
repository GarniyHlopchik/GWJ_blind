extends StateBase

@export var next_state: StateBase

@export_group("Animation and sounds")
@export var animation: String = "preparing";
@export var sound: SoundVisual
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

@onready var timer: Timer = $Timer

func enter(object: EnemyStateMachine):
	super.enter(object)
	timer.start();
	if(sound):
		sound_emiter.emit_wave(sound);
	if(animator && animation):
		animator.play(animation);

func timer_timeout():
	state_machine.change_state(next_state);
	
func exit():
	timer.stop();
