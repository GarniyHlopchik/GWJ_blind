extends VideoStreamPlayer
class_name Cutscene
@export var stop_points: Array[float]
@export var precision: float = 0.05
@export var scene_to_load: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if stop_points and stop_points[0]-precision < stream_position and stream_position < stop_points[0]+precision:
		paused = true
		stop_points.remove_at(0)
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Attack") and paused:
		paused = false


func _on_finished() -> void:
	var scene = scene_to_load.instantiate()
	get_tree().root.add_child(scene)
	queue_free()
