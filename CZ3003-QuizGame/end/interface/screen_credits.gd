extends TextureRect

onready var godot_url_node = get_node("VBoxContainer/HBoxGodot/VBoxContainer/GodotUrl")
onready var back_node = get_node("VBoxContainer/HBoxControls/Back")

func _ready():
	godot_url_node.push_meta(0)
	godot_url_node.append_bbcode("https://godotengine.org")
	godot_url_node.pop()
	
func _on_Back_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")
