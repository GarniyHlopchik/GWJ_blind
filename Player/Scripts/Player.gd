extends CharacterBody2D
class_name Player 

@export var acceleration_time: float
@export var speed = 150.0
@onready var health_component: HealthComponent = $health_component

var direction: Vector2;

func _ready() -> void:
	health_component.on_take_damage.connect(_damage_reaction);
	health_component.on_death.connect(_death);

var knocked: bool = false;

func _damage_reaction(attack_info: AttackInfo):
	knocked = true;
	velocity = attack_info.knockback_dir * attack_info.knockback_strength;
	var timer = Timer.new();
	timer.autostart = true;
	timer.one_shot = true;
	timer.wait_time = attack_info.knockback_time;
	add_child(timer);
	await timer.timeout;
	timer.queue_free()
	knocked = false;
	
func _death():
	queue_free();

func _process(delta: float) -> void:
	PlayerState.position = global_position;

func _physics_process(delta: float) -> void:
	if(knocked):
		move_and_slide()
		return;
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	#print("%s %s" % [direction, direction.length()]);
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	move_and_slide()
