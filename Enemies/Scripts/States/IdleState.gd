extends StateBase

@export var collision_shape_2d: CollisionShape2D;
@export var player_detected_state: StateBase;
@export var see_distance: float = 900;
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export_group("Animation")
@export var animation: String = "idle";
@onready var animator: AnimationPlayer = %animator
	
func enter(obj):
	super.enter(obj);
	if(animator && animation):
		animator.play(animation);
	
func process(delta: float):
	ray_cast_2d.target_position = ray_cast_2d.global_position.direction_to(PlayerState.position) * see_distance
	var collider = ray_cast_2d.get_collider();
	if(collider && collider is Player):
		state_machine.change_state(player_detected_state);
