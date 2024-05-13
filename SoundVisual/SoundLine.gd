extends Line2D
class_name SoundLine

var sound: SoundVisual;
var rays: Array[Node];
const PARTICLE_POINT = preload("res://SoundVisual/particle_point.tscn")
var audio_node: AudioStreamPlayer2D

func _ready() -> void:
	closed = true;
	if(!sound):
		printerr("SoundVisual resource is not set");
		return;
	width = sound.width;
	default_color = sound.color;
	for ray: RayCast2D in rays:	
		var ray_cast_point: Vector2;
		if(ray.is_colliding()):
			ray_cast_point = ray.get_collision_point();
		else:
			ray_cast_point = global_position + ray.target_position
		var point = PARTICLE_POINT.instantiate() as SoundPoint
		point.target_point = ray_cast_point;
		point.position = Vector2.ZERO;
		point.speed = sound.speed;
		add_child(point);
		points.append(Vector2.ZERO)
	if(sound.audio.is_empty()):
		audio_finished = true;
		return;
	var audio_node = AudioStreamPlayer2D.new();
	audio_node.stream = sound.audio.pick_random()
	audio_node.autoplay = true;
	audio_node.finished.connect(func (): audio_finished = true)
	add_child(audio_node);

var lifetime = 0
var fadetime = 0
var audio_finished = false;

func _process(delta: float) -> void:
	if(!sound):
		return;
	var arr = get_children()\
		.filter(func (node): return node is SoundPoint)\
		.map(func (point): return point.position)
	points = PackedVector2Array(arr);
	lifetime += delta;
	if(lifetime > sound.lifetime):
		fadetime += delta;
		default_color.a = 1 - fadetime / sound.fadetime
	if(fadetime > sound.fadetime && audio_finished):
		queue_free();
