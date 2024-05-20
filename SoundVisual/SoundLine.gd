extends Line2D
class_name SoundLine

var sound: SoundVisual;
var rays: Array[Node];
const PARTICLE_POINT = preload("res://SoundVisual/SoundPoint.tscn")
var audio_node: AudioStreamPlayer2D

var colors = [];

func _ready() -> void:
	closed = true;
	if(!sound):
		printerr("SoundVisual resource is not set");
		return;
	width = sound.width;
	default_color = sound.color;
	for ray: RayCast2D in rays:
		var point = PARTICLE_POINT.instantiate() as SoundPoint
		if(ray.is_colliding()):
			point.target_point = ray.get_collision_point();
		else:
			point.target_point = global_position + ray.target_position
		point.position = Vector2.ZERO;
		point.speed = sound.speed;
		add_child(point);
		points.append(Vector2.ZERO)
	gradient = Gradient.new();
	var offset_pos = 0.0;
	var offset = 1.0 / rays.size();
	var offsets: Array[float] = []
	while offset_pos <= 1:
		offsets.append(offset_pos)
		offset_pos += offset
		colors.append(sound.color);
	gradient.offsets = PackedFloat32Array(offsets);
	gradient.colors = PackedColorArray(colors);
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
var existance_time:
	get:
		return sound.lifetime + sound.fadetime
var audio_finished = false;

func get_sound_points() -> Array[Node]:
	return get_children()\
		.filter(func (node): return node is SoundPoint)

func _process(delta: float) -> void:
	if(!sound):
		return;
		
	var sound_points = get_sound_points();
	
	if(gradient):
		for i in sound_points.size():
			if sound_points[i].fade:
				colors[i].a = default_color.a * sound_points[i].percent_to_finish();
				print(colors[i].a)
				gradient.colors = PackedColorArray(colors);
		
	var arr = sound_points\
		.map(func (point): return point.position)
	points = PackedVector2Array(arr);
	lifetime += delta;
	if(lifetime > sound.lifetime):
		fadetime += delta;
		default_color.a = 1 - fadetime / sound.fadetime
	if(fadetime > sound.fadetime && audio_finished):
		queue_free();
