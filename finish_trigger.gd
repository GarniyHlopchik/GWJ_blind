extends Area2D
@export var cutscene: PackedScene
@export var wave: SoundVisual


func _on_area_entered(area: Area2D) -> void:
	var obj = cutscene.instantiate()
	get_tree().root.add_child(obj)
	queue_free()


func _on_timer_timeout() -> void:
	$Timer.start()
	$VisualSoundEmiter.emit_wave(wave)
