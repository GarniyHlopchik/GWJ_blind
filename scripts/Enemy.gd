extends CharacterBody2D


var movement_speed: float = 200.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# These values need to be adjusted for the actor's speed
	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0
	navigation_agent.debug_enabled = true
	
	
func set_movement_target(movement_target: Vector2):
	#print(movement_target)
	navigation_agent.target_position = movement_target

var cooldown = 0;

func _physics_process(_delta):
	#print(navigation_agent.is_target_reachable());
	await get_tree().physics_frame
	
	if(cooldown > 0):
		cooldown -= _delta;
	else:
		set_movement_target(get_global_mouse_position())
		cooldown = 0.2;
	
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	move_and_slide()
