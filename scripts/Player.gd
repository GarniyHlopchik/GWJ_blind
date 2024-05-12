extends CharacterBody2D

@export var acceleration_time: float

@export var speed = 150.0
@export var chord_particle: SoundVisual;
@export var step_paritcle: SoundVisual;
@onready var step_timer: Timer = $step_timer
@onready var chord_cooldown: Timer = $chord_cooldown
@onready var particles: Node2D = $particles

var direction
var chord_ready = true;

const ray_cast_point_amount = 50;

func _ready() -> void:
	var angle = PI * 2 / ray_cast_point_amount;
	var current_angle = deg_to_rad(180);
	for i in ray_cast_point_amount:
		var ray = RayCast2D.new()
		ray.target_position = Vector2(
			sin(current_angle), 
			cos(current_angle)
		) * 3000
		current_angle += angle
		particles.add_child(ray);

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Play") && chord_ready):
		_emit_particle(chord_particle);
		chord_cooldown.start();
		chord_ready = false;
	#print(particles.get_child_count());

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	
	#acceleration
	var tween = get_tree().create_tween()
	if direction:
		tween.tween_property(self,"velocity",direction*speed,acceleration_time)
	else:
		tween.tween_property(self,"velocity",Vector2.ZERO,acceleration_time)
	if(direction && step_timer.is_stopped()):
		step_timer.start();
	elif(!direction && !step_timer.is_stopped()):
		step_timer.stop();
	move_and_slide()
	

func _emit_particle(sound: SoundVisual):
	var line = SoundLine.new()
	line.global_position = global_position;
	line.rays = particles.get_children() as Array[RayCast2D];
	line.sound = sound
	get_parent().add_child(line);
	

func _on_chord_cooldown_timeout() -> void:
	chord_ready = true;

func _on_step_timer_timeout() -> void:
		_emit_particle(step_paritcle);
	
	#pass
