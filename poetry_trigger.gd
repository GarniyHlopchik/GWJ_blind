extends Area2D
@export var text: String
@export var voice: AudioStream

func _on_body_entered(body: Node2D) -> void:
	print("yep")
	if body.name == "player":
		print("absolutly")
		body.display_text(text,voice)
