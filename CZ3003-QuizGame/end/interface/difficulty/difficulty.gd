extends Control

onready var easyLvl = $Container/VSplitContainer/VBoxContainer2/HBoxContainer/Easy
onready var difficultLvl = $Container/VSplitContainer/VBoxContainer2/HBoxContainer/Difficult
onready var lunaticLvl = $Container/VSplitContainer/VBoxContainer2/HBoxContainer/Lunatic
# Called when the node enters the scene tree for the first time.
func _ready():
	match int(Firebase.worldSelected):
		1:
			if(int(Firebase.profile.W1L1Score.integerValue) < 2000):
				difficultLvl.hide()
				lunaticLvl.hide()
			elif(int(Firebase.profile.W1L2Score.integerValue) < 2000):
				lunaticLvl.hide()
		2:
			if(int(Firebase.profile.W2L1Score.integerValue) < 2000):
				difficultLvl.hide()
				lunaticLvl.hide()
			elif(int(Firebase.profile.W2L2Score.integerValue) < 2000):
				lunaticLvl.hide()
		3:
			if(int(Firebase.profile.W3L1Score.integerValue) < 2000):
				difficultLvl.hide()
				lunaticLvl.hide()
			elif(int(Firebase.profile.W3L2Score.integerValue) < 2000):
				lunaticLvl.hide()
		4:
			if(int(Firebase.profile.W4L1Score.integerValue) < 2000):
				difficultLvl.hide()
				lunaticLvl.hide()
			elif(int(Firebase.profile.W4L2Score.integerValue) < 2000):
				lunaticLvl.hide()
		5:
			if(int(Firebase.profile.W5L1Score.integerValue) < 2000):
				difficultLvl.hide()
				lunaticLvl.hide()
			elif(int(Firebase.profile.W5L2Score.integerValue) < 2000):
				lunaticLvl.hide()

func _on_BackButton_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")

func _on_Easy_pressed():
	Firebase.difficultySelected = "EASY"
	Firebase.levelSelected = 1
	return get_tree().change_scene("res://interface/game/game.tscn")


func _on_Hard_pressed():
	Firebase.difficultySelected = "DIFFICULT"
	Firebase.levelSelected = 2
	return get_tree().change_scene("res://interface/game/game.tscn")


func _on_Lunatic_pressed():
	Firebase.difficultySelected = "LUNATIC"
	Firebase.levelSelected = 3
	return get_tree().change_scene("res://interface/game/game.tscn")
