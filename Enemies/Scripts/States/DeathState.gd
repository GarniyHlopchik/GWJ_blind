extends ConditionalStateBase

@export var health_component: HealthComponent;

@export_group("Animation and sounds")
@export var animation: String = "death";
@export var sound: SoundVisual;
@onready var animator: AnimationPlayer = %animator
@onready var sound_emiter: VisualSoundEmiter = %sound_emiter;

func condition() -> bool:
	if(is_instance_valid(health_component)):
		return health_component.hp <= 0;
	return true;

func enter(obj):
	super.enter(obj);
	if(animator && animation):
		animator.play(animation);
	if(sound_emiter && sound):
		sound_emiter.emit_wave(sound);
	if(is_instance_valid(health_component)):
		health_component.queue_free();
	var timer = Timer.new();
	add_child(timer);
	timer.start(2);
	await timer.timeout;
	state_machine.queue_free();
