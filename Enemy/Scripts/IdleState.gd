extends StateBase

@export var collision_shape_2d: CollisionShape2D;
@export var player_detected_state: StateBase;
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var state_machine: EnemyStateMachine;
func enter(object: EnemyStateMachine):
	state_machine = object;
	
func process(delta: float):
	ray_cast_2d.target_position = PlayerState.position - ray_cast_2d.global_position
	var collider = ray_cast_2d.get_collider();
	if(collider is Player):
		state_machine.change_state(player_detected_state);
