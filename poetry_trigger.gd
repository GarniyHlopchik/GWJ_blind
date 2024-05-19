extends Area2D
@export var text: String
@export var voice: AudioStream

func _on_body_entered(body: Node2D) -> void:
	print("yep")
	if body.name == "player":
		print("absolutly")
		body.display_text(text,voice)


func _on_area_entered(area: Area2D) -> void:
	print("yep_a")
	if area.name == "health_component":
		print("absolutly")
		area.get_parent().display_text(text,voice)
		queue_free()
