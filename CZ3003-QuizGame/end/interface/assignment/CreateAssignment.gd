extends Node

# Declare member variables here. Examples:
onready var http : HTTPRequest = $HTTPRequest
onready var question : Label = $Container/VBoxContainer2/Question/LineEdit
onready var answer1 : Label = $Container/VBoxContainer2/Answer1/LineEdit
onready var notification : Label = $Container/Notification
onready var answer2 : Slider = $Container/VBoxContainer2/Answer2/LineEdit
onready var answer3 : Slider = $Container/VBoxContainer2/Answer3/LineEdit
onready var answer4 : Slider = $Container/VBoxContainer2/Answer4/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.get_document("levels/%s" % Firebase.user_info.id, http)
	print(Firebase.user_info.id)

func _on_Button_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")

var new_level := false
var information_sent := false
var level := {
	"question": {},
	"answer1": {},
	"answer2": {},
	"answer3": {},
	"answer4": {}
} setget set_level

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			notification.text = "Please, enter your information"
			new_level = true
			return
		200:
			if information_sent:
				notification.text = "Information saved successfully"
				information_sent = false
			self.level = result_body.fields


func _on_ConfirmButton_pressed() -> void:
	if question.text.empty() or answer1.text.empty() or answer2.text.empty() or answer3.text.empty() or answer4.text.empty():
		notification.text = "Please, enter the question and answers"
		return
	level.question = { "stringValue": question.text }
	level.answer1 = { "stringValue": answer1.text }
	level.answer2 = { "stringValue": answer2.text }
	level.answer3 = { "stringValue": answer3.text }
	level.answer4 = { "stringValue": answer4.text }
	match new_level:
		true:
			Firebase.save_document("levels?documentId=%s" % Firebase.user_info.id, level, http)
		false:
			Firebase.update_document("levels/%s" % Firebase.user_info.id, level, http)
	information_sent = true


func set_level(value: Dictionary) -> void:
	level = value
	question.text = level.question.stringValue
	answer1.text = level.answer1.stringValue
	answer2.text = level.answer2.stringValue
	answer3.text = level.answer3.stringValue
	answer4.text = level.answer4.stringValue