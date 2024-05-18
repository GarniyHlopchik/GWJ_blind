extends Node
class_name StateBase

var state_machine: EnemyStateMachine
## Invokes when the enemy changes state to this. Use to reset local variables to default values
func enter(object: EnemyStateMachine):
	state_machine = object;
## Invokes every process tick by EnemyStateMachine
func process(delta: float):
	pass
## Invokes every physics_process tick by EnemyStateMachine when the state is current
func physics_process(delta: float):
	pass
## Invokes when the enemy changes state from this.
func exit():
	pass;
