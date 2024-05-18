extends StateBase

@export var navigation_agent: NavigationAgent2D;
@export var movement_speed: float = 150;
@export var close_distance: float = 125;
@export var when_close_state: StateBase;
@export var lost_interest_state: StateBase;
@export var min_walking_time: float;

@export_group("Animation and sounds")
@export var animation: String = "run";
@export var step_sound: SoundVisual;
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

@onready var interest_time: Timer = $interest_time
@onready var step_timer: Timer = $step_timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var min_walking_timer: Timer = $min_walking_timer

var can_attack = true;

func enter(object: EnemyStateMachine):
	super.enter(object);
	interest_time.start();
	step_timer.start()
	if(animator && animation):
		animator.play(animation);
	if(min_walking_time > 0):
		can_attack = false;
		min_walking_timer.start(min_walking_time);
	
func exit():
	interest_time.stop();
	step_timer.stop();
	
func _on_invoke_time_timeout() -> void:
	if(!is_seeing_player):
		state_machine.change_state(lost_interest_state)
	else: interest_time.start();
	
func _on_step_timer_timeout() -> void:
	#TODO: додати умови
	sound_emiter.emit_wave(step_sound);
	pass # Replace with function body.

var is_seeing_player: bool;
func process(delta: float):
	ray_cast_2d.target_position = PlayerState.position - ray_cast_2d.global_position
	var collider = ray_cast_2d.get_collider();
	is_seeing_player = collider is Player;
	if(is_seeing_player):
		interest_time.start();

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

var cooldown = 0;
func physics_process(delta: float) -> void:
	#if(knockback_timeleft>0):
		#velocity = knockback;
		#knockback = lerp(Vector2.ZERO, attack.knockback_dir*attack.knockback_strength,
			#knockback_timeleft / attack.knockback_time
		#);
		#knockback_timeleft -= _delta;
		#move_and_slide();
		#return;
	#print(navigation_agent.is_target_reachable());
	await get_tree().physics_frame
	
	if(cooldown > 0):
		cooldown -= delta;
	else:
		set_movement_target(PlayerState.position)
		cooldown = 0.2;
	
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = state_machine.global_position;
	if(current_agent_position.distance_to(PlayerState.position) < close_distance && 
		is_seeing_player && can_attack):
		state_machine.change_state(when_close_state);
		return;
		
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	state_machine.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	state_machine.move_and_slide();


func _on_min_walking_timer_timeout() -> void:
	can_attack = true;
