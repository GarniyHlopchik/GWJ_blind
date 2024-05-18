extends Area2D
class_name PoetryTrigger
@export var text: String
func _ready() -> void:
	connect("body_entered",display)
func display(body):
	body.display_text(text)
