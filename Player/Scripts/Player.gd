extends CharacterBody2D
class_name Player 

@export var acceleration_time: float
@export var speed = 150.0
@onready var health_component: HealthComponent = $health_component

@export var menu_scene: PackedScene

@export var wave_interval_time : float = 0.5
var wave_interval_timer : float= 0.0

@onready var sw_manager: SWManager = %SWManager

@onready var sound_emiter: VisualSoundEmiter = %sound_emiter

var direction: Vector2;

func _ready() -> void:
	health_component.on_take_damage.connect(_damage_reaction);
	health_component.on_death.connect(_death);
	SWSignal.sw_screen_ready.connect(_on_sw_screen_ready)
	
func _on_sw_screen_ready(_sw_screen: SWScreen) -> void:
	_sw_screen.node_to_follow = self

var knocked_velocity: Vector2;
var knocked_timer: Timer;

func _process(delta: float) -> void:
	PlayerState.position = global_position;
	wave_interval_timer = max( wave_interval_timer - delta, 0.0)

	if Input.is_action_pressed("Play") and is_zero_approx(wave_interval_timer):
		wave_interval_timer = wave_interval_time
		var wave_launched := await sw_manager.ask_for_next_wave()
		print( "is wave launched : ", wave_launched)


func _damage_reaction(attack_info: AttackInfo):
	#$hit_sfx.stream = hit_sfx[randi_range(0,3)]
	#$hit_sfx.play()
	sound_emiter.emit_wave(attack_info.sound_visual);
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
	health_component.queue_free()

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
@export var fade_time: float
@export var delay_time: float
@export var life_time: float
var is_displaying = false
func display_text(text,voice):
	if is_displaying:
		return
	is_displaying = true
	$voice.stream = voice
	$voice.play()
	var words_arr = text.split("/")
	for i in words_arr:
		i = i.split(" ")
		var h_box = HBoxContainer.new()
		#h_box.alignment = BoxContainer.ALIGNMENT_CENTER
		%text.add_child(h_box)
		for a in i:
			var label = Label.new()
			label.text = a+" "
			%text.get_node(str(h_box.name)).add_child(label)
			var tween = get_tree().create_tween()
			label.modulate.a = 0.0
			tween.tween_property(label,"modulate:a",1.0,fade_time)
			await get_tree().create_timer(delay_time).timeout
	await get_tree().create_timer(life_time).timeout
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	for i in %text.get_children():
		for a in i.get_children():
			tween.tween_property(a,"modulate:a",0.0,fade_time)
	for i in %text.get_children():
		i.queue_free()
	is_displaying = false


func _on_word_timeout_timeout() -> void:
	pass # Replace with function body.
