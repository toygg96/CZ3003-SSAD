extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_BackButton_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")

func _on_World1_pressed():
	Firebase.worldSelected = "World1"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")

func _on_World3_pressed():
	Firebase.worldSelected = "World2"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")

func _on_World2_pressed():
	Firebase.worldSelected = "World3"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")

func _on_World4_pressed():
	Firebase.worldSelected = "World4"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")

func _on_World5_pressed():
	Firebase.worldSelected = "World5"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")

func _on_World6_pressed():
	Firebase.worldSelected = "World6"
	return get_tree().change_scene("res://interface/difficulty/difficulty.tscn")
