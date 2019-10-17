extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_BackButton_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")

func _on_Easy_pressed():
	Firebase.difficultySelected = "EASY"
	return get_tree().change_scene("res://interface/game/game.tscn")


func _on_Hard_pressed():
	Firebase.difficultySelected = "DIFFICULT"
	return get_tree().change_scene("res://interface/game/game.tscn")


func _on_Lunatic_pressed():
	Firebase.difficultySelected = "LUNATIC"
	return get_tree().change_scene("res://interface/game/game.tscn")
