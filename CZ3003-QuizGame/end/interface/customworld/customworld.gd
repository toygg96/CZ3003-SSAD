extends Control

onready var http : HTTPRequest = $HTTPRequest

var profile := {
	"name": {},
	"createTime": {},
	"updateTime": {}
} 

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.get_document("custom/", http)


func _on_BackButton_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("MOTHER FUCKER")
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	print(response_code)
	match response_code:
		404:
			print("you suck")
			return
		200:
			for users in result_body.documents:
				profile = users.fields
				if (profile.nickname.stringValue != "GodMode") :
					print("Correct username: " + profile.nickname.stringValue)
					user.append(profile)
