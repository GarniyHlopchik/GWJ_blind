extends CharacterBody2D
class_name EnemyStateMachine

@export var begining_state: StateBase
@export var any_states: Array[ConditionalStateBase];
var _current_state: StateBase;

func _ready() -> void:
	change_state(begining_state);

func change_state(state: StateBase):
	if(!is_instance_valid(state)): return;
	if(is_instance_valid(_current_state)):
		await _current_state.exit()
	_current_state = state;
	_current_state.enter(self);
	

func _process(delta: float) -> void:
	for state in any_states:
		if(state.condition() && _current_state != state):
			change_state(state);
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true		
	_current_state.process(delta);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta);
