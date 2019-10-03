extends TextureRect

func _on_Quit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	return get_tree().change_scene("res://interface/screen_credits.tscn")
	
func _on_Profile_pressed():
	return get_tree().change_scene("res://interface/profile/UserProfile.tscn")