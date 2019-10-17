extends TextureRect

onready var username : LineEdit = $VBoxMain/VBoxGreeting/LabelName
onready var createLevelBtn = $VBoxMain/VBoxContainer/HBoxMenu/VBoxContainer/CreateLevel

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
	if(Firebase.username == "teacher"):
		createLevelBtn.set_text("CREATE ASSIGNMENT")
	else:
		pass
		

func _on_StartGame_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")

func _on_Signout_pressed():
	get_tree().change_scene("res://interface/login/Login.tscn")