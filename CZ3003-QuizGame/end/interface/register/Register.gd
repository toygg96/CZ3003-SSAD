extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/VBoxContainer2/Username/LineEdit
onready var password : LineEdit = $Container/VBoxContainer2/Password/LineEdit
onready var confirm : LineEdit = $Container/VBoxContainer2/Confirm/LineEdit
onready var notification : Label = $Container/Notification


func _on_RegisterButton_pressed() -> void:
	if username.text.empty() or password.text.empty() or confirm.text.empty():
		if username.text.empty() and password.text.empty():
			notification.text  = "Missing username and password!"
			return
		elif confirm.text.empty():
			notification.text =  "Missing confirmed password!"
			return
		elif username.text.empty():
			notification.text = "Missing username!"
			return
		elif password.text.empty():
			notification.text = "Missing password!"
			return
	else:
		if username.text == password.text:
			notification.text = "Username and Password are identical, please choose a new password!"
			return
		elif password.text != confirm.text:
			notification.text = "Confirmed password do not match the password entered!"
			return
		else:
			Firebase.register(username.text + "@ntu.com", password.text, http)
	


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		notification.text = "Registration is sucessful!"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://interface/login/Login.tscn")
	

func _on_BackButton_pressed():
	get_tree().change_scene("res://Main.tscn") 
