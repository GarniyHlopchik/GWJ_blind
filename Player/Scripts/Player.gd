extends CharacterBody2D
class_name Player 

@export var acceleration_time: float
@export var speed = 150.0
@onready var health_component: HealthComponent = $health_component

var direction: Vector2;

func _ready() -> void:
	health_component.on_take_damage.connect(_damage_reaction);
	health_component.on_death.connect(_death);

var knocked_velocity: Vector2;
var knocked_timer: Timer;

func _damage_reaction(attack_info: AttackInfo):
	knocked_velocity = attack_info.knockback_dir * attack_info.knockback_strength;
	print(knocked_velocity.length())
	knocked_timer = Timer.new();
	knocked_timer.autostart = true;
	knocked_timer.one_shot = true;
	knocked_timer.wait_time = attack_info.knockback_time;
	add_child(knocked_timer);
	await knocked_timer.timeout;
	#print("knock-end")
	knocked_timer.queue_free()
	knocked_velocity = Vector2.ZERO;
	
func _death():
	queue_free();

func _process(delta: float) -> void:
	PlayerState.position = global_position;

func _physics_process(delta: float) -> void:
	if(knocked_velocity != Vector2.ZERO):
		velocity = knocked_velocity;
		knocked_velocity = lerp(Vector2.ZERO, knocked_velocity, (.1 + knocked_timer.time_left) / knocked_timer.wait_time)
		move_and_slide()
		return;
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	if !can_move: return;
	#print("%s %s" % [direction, direction.length()]);
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	move_and_slide()

var can_move: bool = true;

func _got_up():
	can_move = true;

func _on_sit() -> void:
	can_move = false
func display_text(text,voice):
	print(text)
	$voice.stream = voice
	$voice.play()
