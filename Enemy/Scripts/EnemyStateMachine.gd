extends CharacterBody2D
class_name EnemyStateMachine

@export var begining_state: StateBase
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
	#print(_current_state)
	_current_state.process(delta);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta);
