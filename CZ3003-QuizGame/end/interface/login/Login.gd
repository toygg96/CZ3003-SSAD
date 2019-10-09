extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/VBoxContainer2/Username/LineEdit
onready var password : LineEdit = $Container/VBoxContainer2/Password/LineEdit
onready var notification : Label = $Container/Notification


func _on_LoginButton_pressed() -> void:
	if username.text.empty() or password.text.empty():
		if username.text.empty() and password.text.empty():
			notification.text = "Please, enter your username and password"
			return
		elif username.text.empty():
			notification.text = "Please, enter your username"
			return
		else:
			notification.text = "Please, enter your password"
			return
	Firebase.login(username.text + "@ntu.com", password.text, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		return
	else:
		notification.text = "Sign in sucessful!"
		Firebase.username = username.text;
		get_tree().change_scene("res://interface/MenuGame.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://Main.tscn") 
