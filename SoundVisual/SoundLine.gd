extends Line2D
class_name SoundLine

var sound: SoundVisual;
var rays: Array[Node];
const PARTICLE_POINT = preload("res://SoundVisual/SoundPoint.tscn")
var audio_node: AudioStreamPlayer2D

var start_pos:Vector2;
func _ready() -> void:
	closed = true;
	if(!sound):
		printerr("SoundVisual resource is not set");
		return;
	width = sound.width;
	default_color = sound.color;
	start_pos = global_position;
	global_position = Vector2.ZERO;
	for ray: RayCast2D in rays:	
		var ray_cast_point: Vector2;
		if(ray.is_colliding()):
			ray_cast_point = ray.get_collision_point();
		else:
			ray_cast_point = start_pos + ray.target_position
		var point = PARTICLE_POINT.instantiate() as SoundPoint
		point.target_point = ray_cast_point;
		point.position = Vector2.ZERO;
		point.speed = sound.speed;
		add_child(point);
		point.global_position = start_pos;
		points.append(Vector2.ZERO)
	if(sound.audio.is_empty()):
		audio_finished = true;
		return;
	var audio_node = AudioStreamPlayer2D.new();
	audio_node.stream = sound.audio.pick_random()
	audio_node.autoplay = true;
	audio_node.finished.connect(func (): audio_finished = true)
	add_child(audio_node);
	audio_node.global_position = start_pos;

var lifetime = 0
var fadetime = 0
var existance_time:
	get:
		return sound.lifetime + sound.fadetime
var audio_finished = false;
	
func get_global_polygon():
	var arr = Array(points).map(func (p): return p + global_position);
	return PackedVector2Array(arr);

func merge_polygons():
	var lines = get_tree().root\
		.get_children(true)\
		.filter(func (n): return n is SoundLine) as Array[SoundLine];
	for line in lines:
		if(line.sound != sound): continue;
		var line_polygon = line.get_global_polygon()
		var new_polygons = Geometry2D.intersect_polyline_with_polygon(line_polygon, get_global_polygon());
		#print(line.name, " ", new_polygons.size() > 0)
		if(new_polygons.size() > 0):
			#points = new_polygons[0]
			var merge = Geometry2D.merge_polygons(get_global_polygon(), line_polygon)[0]
			points = merge

var is_static = false
func get_sound_points() -> Array[Node]:
	return get_children()\
		.filter(func (node): return node is SoundPoint);

func _process(delta: float) -> void:
	if(!sound):
		return;
	lifetime += delta;
	if(lifetime > sound.lifetime):
		fadetime += delta;
		default_color.a = 1 - fadetime / sound.fadetime
	if(fadetime > sound.fadetime):
		var sound_points = get_sound_points() as Array[SoundPoint];
		for point in sound_points:
			if(point.is_finish && !point.is_reversed):
				point.reverse();
	if(fadetime > sound.fadetime * 2):
		queue_free();
		
		
		
	if(!is_static):
		var arr = get_sound_points()\
			.map(func (point): return point.position)
		var new_points = PackedVector2Array(arr);
		if(new_points != points):
			points = new_points;
		else:
			print("set static")
			is_static = true;
	merge_polygons();
