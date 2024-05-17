extends ConditionalStateBase

@export var state_after: StateBase;

@export_group("Animation and sounds")
@export var animation: String = "knocked";
@export var sound: SoundVisual;
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

var damage_taken: bool = false;
var attack: AttackInfo;

func on_take_damage(attack_info: Variant) -> void:
	damage_taken = true;
	attack = attack_info;
	

func condition() -> bool: 
	return damage_taken;

var knockback: Vector2; 
var knockback_timeleft: float; 
func enter(object: EnemyStateMachine):
	super.enter(object)
	damage_taken = false;
	knockback = attack.knockback_dir * attack.knockback_strength;
	knockback_timeleft = attack.knockback_time;
	if(animator && animation):
		animator.play(animation);
	if(sound_emiter && sound):
		sound_emiter.emit_wave(sound);

func physics_process(delta: float):
	if(knockback_timeleft>0):
		state_machine.velocity = knockback;
		knockback = lerp(Vector2.ZERO, attack.knockback_dir*attack.knockback_strength,
			knockback_timeleft / attack.knockback_time
		);
		knockback_timeleft -= delta;
		state_machine.move_and_slide();
	else:
		state_machine.change_state(state_after);
## Invokes when the enemy changes state from this.
func exit():
	pass;
