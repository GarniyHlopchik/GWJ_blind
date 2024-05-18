extends Timer
class_name SitTimer

@onready var player: Player = $".."

var is_sit: bool:
	get:
		return PlayerState.is_sit;
	set(value):
		PlayerState.is_sit = value;
signal on_sit();
signal on_get_up();

func _ready() -> void:
	on_sit.connect(sit)
	on_get_up.connect(get_up)
	timeout.connect(func (): 
		on_sit.emit() 
		stop()
	);

func sit():
	is_sit = true;
func get_up():
	is_sit = false

func _process(delta: float) -> void:
	if(player.direction.length() == 0 && !is_sit && is_stopped()):
		start();
	if(player.direction.length() > 0):
		if(!is_stopped()):
			stop();
		if(is_sit):
			on_get_up.emit();
