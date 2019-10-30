
extends Control
onready var http : HTTPRequest = $HTTPRequest

var user = []
var buttonGrp = []
var x = 190
var y = 160
var count = 0
var i = 0
var profile := {
	"name": {},
	"createTime": {},
	"updateTime": {}
} 

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.get_document("custom/", http)
	OS.set_window_size(Vector2(1920,1080))
	set_size(OS.get_window_size())
	yield(get_tree().create_timer(1.8), "timeout")
	while (i < count) :
		var button1 = Button.new()
		button1.set_position(Vector2(x,y))
		button1.set_size(Vector2(350,85))
		button1.add_font_override("font",load("res://interface/fonts/montserrat_eb_64.tres"))
		button1.set_text(user[i]["name"])
		button1.show()
		add_child(button1)
		i = i + 1
		x = x + 370


func _on_BackButton_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	print(response_code)
	match response_code:
		404:
			return
		200:
			for users in result_body.documents:
				print(users)
				count = count + 1
				profile = users
				profile.name = profile.name.replace("projects/ssadquiz/databases/(default)/documents/custom/", "")
				user.append(profile)

				

