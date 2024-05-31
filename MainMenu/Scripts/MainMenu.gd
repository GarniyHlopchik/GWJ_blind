extends Control

const TEST_SCENE = preload("res://TestScene.tscn")

func start():
	var parrent = get_parent();
	parrent.add_child(TEST_SCENE.instantiate());
	queue_free();

func quit():
	get_tree().quit();
