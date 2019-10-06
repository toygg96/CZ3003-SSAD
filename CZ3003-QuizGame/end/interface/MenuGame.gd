extends TextureRect

onready var username : LineEdit = $VBoxMain/VBoxGreeting/LabelName

func _on_Quit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	return get_tree().change_scene("res://interface/screen_credits.tscn")
	
func _on_Profile_pressed():
	return get_tree().change_scene("res://interface/profile/UserProfile.tscn")

func _on_CreateLevel_pressed():
	return get_tree().change_scene("res://interface/assignment/CreateAssignment.tscn")

func _ready() -> void:
	username.text = "Welcome " + Firebase.username

func _on_StartGame_pressed():
	return get_tree().change_scene("res://interface/game/game.tscn")
