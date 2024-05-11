extends CharacterBody2D


@export var speed = 150.0
@export var chord_particle: PackedScene;
@export var step_paritcle: PackedScene;
@onready var step_timer: Timer = $step_timer
@onready var chord_cooldown: Timer = $chord_cooldown
@onready var particles: Node2D = $particles

var chord_ready = true;

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Play") && chord_ready):
		_emit_particle(chord_particle);
		chord_cooldown.start();
		chord_ready = false;

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down");
	velocity = direction * speed
	if(direction && step_timer.is_stopped()):
		step_timer.start();
	elif(!direction && !step_timer.is_stopped()):
		step_timer.stop();
	move_and_slide()

func _emit_particle(particle: PackedScene):
	if(!particle): return;
	var node = particle.instantiate() as GPUParticles2D;
	node.emitting = true;
	node.one_shot = true;
	node.finished.connect(func(): remove_child(node));
	particles.add_child(node);

func _on_chord_cooldown_timeout() -> void:
	chord_ready = true;

func _on_step_timer_timeout() -> void:
	_emit_particle(step_paritcle);
