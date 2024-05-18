extends StateBase

@export var attack_speed: float = 2;
@export var after_attack_state: StateBase;
@export var attack_info: AttackInfo;

@export_group("Animation and sounds")
@export var animation: String = "attack";
@export var step_sound: SoundVisual;
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

@onready var step_timer: Timer = $step_timer
@onready var duration_timer: Timer = $duration_timer
@onready var hit_collision: CollisionShape2D = $hit_area/hit_collision

var move_direction: Vector2;


## Invokes when the enemy changes state to this. Use to reset local variables to default values
func enter(object):
	super.enter(object);
	if(animator && animation):
		animator.play(animation);
	step_timer.start();
	duration_timer.start();
	hit_collision.disabled = false;
	move_direction = object.global_position.direction_to(PlayerState.position) * attack_speed;

func step():
	if(sound_emiter && step_sound):
		sound_emiter.emit_wave(step_sound);
		
func end_of_attack():
	state_machine.change_state(after_attack_state);
	
func area_entered(area: Area2D):
	if(hit_collision.disabled): return;
	if(area is HealthComponent):
		var attack = attack_info.duplicate() as AttackInfo;
		attack.knockback_dir = move_direction.normalized();
		area.deal_damage(attack);
		hit_collision.disabled = true;
		state_machine.change_state(after_attack_state);

## Invokes every physics_process tick by EnemyStateMachine when the state is current
func physics_process(delta: float):
	state_machine.velocity = move_direction;
	state_machine.move_and_slide();
	
## Invokes when the enemy changes state from this.
func exit():
	step_timer.stop();
	duration_timer.stop();
	hit_collision.disabled = true;
