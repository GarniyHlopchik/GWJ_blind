extends Node2D
@export var zoom_time: float
@export var zoom_delta: float
@export var ahead_distance: float
@export var follow_distance: float
@export var arrive_time: float
@onready var player = get_parent()
@onready var default_zoom = $Camera2D.zoom
var is_elevator_shake = false
var shake_intensity = 0
var shake_duration = 0


func elevator_shake():
	if is_elevator_shake:
		
		
		$elevator_tween_timer.start()
		var newPos = Vector2(randf_range(-5.0,5.0),randf_range(-5.0,5.0))
		
		var elevator_tween = get_tree().create_tween()
		elevator_tween.tween_property($Camera2D,"position",newPos,0.5).set_ease(Tween.EASE_IN_OUT)
	

func _ready() -> void:
	global_position = player.global_position
	

func _process(delta: float) -> void:
	
	#camera movement
	var tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	
	#zoom
	if get_parent().direction:
		tween.tween_property($Camera2D,"zoom",default_zoom-Vector2(zoom_delta,zoom_delta),zoom_time).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property($Camera2D,"zoom",default_zoom,zoom_time).set_ease(Tween.EASE_IN_OUT)
	
	
	var mouse_pos = get_global_mouse_position()
	
	var follow_position = player.global_position + player.global_position.direction_to(mouse_pos)*ahead_distance*player.global_position.distance_to(mouse_pos)
	tween.tween_property(self,"global_position",follow_position,arrive_time).set_ease(Tween.EASE_IN_OUT)
	
	#camera shake
	if $Camera2D/shake_timer.time_left > 0:
		
		$Camera2D.position.x = move_toward($Camera2D.position.x,randf_range(-1,1)*shake_intensity*$Camera2D/shake_timer.time_left,50)
	elif not is_elevator_shake:
		$Camera2D.position.x = 0
		
func shake(_intensity,_duration):
	shake_intensity = _intensity
	shake_duration = _duration
	$Camera2D/shake_timer.wait_time = _duration
	$Camera2D/shake_timer.start()
func start_elevator_shake():
		is_elevator_shake = true
		elevator_shake()

	
func elevator_shake_end():
	is_elevator_shake = false
	

func _on_shake_timer_timeout() -> void:
	shake_intensity = 0
	shake_duration = 0


func _on_elevator_tween_timer_timeout() -> void:
	if is_elevator_shake:
		elevator_shake()
