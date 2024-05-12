extends Line2D
class_name SoundLine

var sound: SoundVisual;
var rays: Array[Node];
const PARTICLE_POINT = preload("res://SoundVisual/particle_point.tscn")

func _ready() -> void:
	closed = true;
	if(!sound):
		printerr("SoundVisual resource is not set");
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

var lifetime = 0
var fadetime = 0

func _process(delta: float) -> void:
	var arr = get_children().map(func (point): return point.position)
	points = PackedVector2Array(arr);
	lifetime += delta;
	if(lifetime > sound.lifetime):
		fadetime += delta;
		default_color.a = 1 - fadetime / sound.fadetime
	if(fadetime > sound.fadetime):
		queue_free();
