extends Timer
class_name SitTimer

@onready var player: Player = $".."

var is_sit: bool;
signal on_sit();
signal on_get_up();

func _ready() -> void:
	on_sit.connect(func (): is_sit = true)
	on_get_up.connect(func (): is_sit = false)
	timeout.connect(func (): 
		on_sit.emit() 
		stop()
	);

func _process(delta: float) -> void:
	if(player.direction.length() == 0 && !is_sit && is_stopped()):
		start();
	if(player.direction.length() > 0):
		if(!is_stopped()):
			stop();
		if(is_sit):
			on_get_up.emit();