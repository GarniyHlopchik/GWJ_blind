extends HBoxContainer

@export_multiline var text = "Blind Bard"
@export var settings: LabelSettings;
const LETTER = preload("res://MainMenu/Prefabs/Letter.tscn")
func _ready() -> void:
	for char in text:
		var letter = LETTER.instantiate();
		letter.text = char;
		letter.label_settings = settings.duplicate();
		add_child(letter);
