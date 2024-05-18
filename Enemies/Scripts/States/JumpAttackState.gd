extends StateBase

@export var damage: int = 1;
@export var attack_force: float = 6;
@export var attack_info: AttackInfo;
@export var after_attack_state: StateBase;

@export_group("Animation and sounds")
@export var animation: String = "attack";
@export var sound: SoundVisual;
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

@onready var timer: Timer = $Timer
@onready var hit_area: Area2D = $hit_area
@onready var hit_collision: CollisionShape2D = $hit_area/hit_collision

var velocity_dir: Vector2;

func enter(object: EnemyStateMachine):
	super.enter(object)
	if(animator && animation):
		animator.play(animation);
	if(sound_emiter && sound):
		sound_emiter.emit_wave(sound);
	hit_collision.disabled = false;
	timer.start()
	velocity_dir = (PlayerState.position - state_machine.global_position) * attack_force
	
func physics_process(delta: float):
	state_machine.velocity = velocity_dir;
	velocity_dir = lerp(Vector2.ZERO, velocity_dir, timer.time_left / timer.wait_time);
	state_machine.move_and_slide();

func _on_hit_area_area_entered(area: Area2D) -> void:
	if(area is HealthComponent):
		var health = area as HealthComponent;
		health.deal_damage(attack_info);
		hit_collision.disabled = true;

func _on_timer_timeout() -> void:
	state_machine.change_state(after_attack_state)

func exit():
	timer.stop()
	hit_collision.disabled = true;



