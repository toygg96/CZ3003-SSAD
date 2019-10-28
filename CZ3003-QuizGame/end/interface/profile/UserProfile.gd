extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var back_button = $Container/VBoxContainer2/HBoxContainer/HBoxContainer2/BackButton
onready var confirm_button = $Container/VBoxContainer2/HBoxContainer/HBoxContainer/ConfirmButton
onready var title : Label = $Container/Title
onready var nickname : Label = $Container/VBoxContainer2/Name/LineEdit
onready var character_class : Label = $Container/VBoxContainer2/Class/LineEdit
onready var notification : Label = $Container/Notification
onready var HP : Slider = $Container/VBoxContainer2/HP/HP_Slider
onready var AP : Slider = $Container/VBoxContainer2/AP/AP_Slider
onready var overallScore : Label = $Container/VBoxContainer2/Score/Label2

var information_sent := false
var profile := {
	"nickname": {},
	"character_class": {},
	"HP": {},
	"AP": {},
	"W1Score": {},
	"W2Score": {},
	"W3Score": {},
	"W4Score": {},
	"W5Score": {},
	"overallScore": {}
} setget set_profile


func _ready() -> void:
	if (Firebase.new_character):
		title.set_text("CREATE NEW CHARACTER")
		HP.set_editable(false)
		AP.set_editable(false)
		back_button.hide()
	elif (Firebase.upgrade_character) :
		Firebase.upgrade_character = false
		title.set_text("UPGRADE CHARACTER")
		fetchExistingProfiel()	
	else:
		title.set_text("VIEW CHARACTER")
		nickname.set_editable(false)
		character_class.set_editable(false)
		HP.set_editable(false)
		AP.set_editable(false)
		confirm_button.hide()
		fetchExistingProfiel()	
	#Firebase.get_document("users/%s" % Firebase.username, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			notification.text = "Please, enter your information"
			Firebase.new_character = true
			return
		200:
			if information_sent:
				notification.text = "Information saved successfully"
				information_sent = false
				Firebase.new_character = false
				get_tree().change_scene("res://interface/MenuGame.tscn")
			self.profile = result_body.fields


func _on_ConfirmButton_pressed() -> void:
	if nickname.text.empty() or character_class.text.empty():
		notification.text = "Please, enter your nickname and class"
		return
	profile.nickname = { "stringValue": nickname.text }
	profile.character_class = { "stringValue": character_class.text }
	profile.HP = { "integerValue": HP.value }
	profile.AP = { "integerValue": AP.value }
	match Firebase.new_character:
		true:	
			HP.value = 5
			AP.value = 5
			profile.W1Score = { "integerValue": 0}
			profile.W2Score = { "integerValue": 0}
			profile.W3Score = { "integerValue": 0}
			profile.W4Score = { "integerValue": 0}
			profile.W5Score = { "integerValue": 0}
			profile.overallScore = { "integerValue": 0 }
			profile.HP = { "integerValue": HP.value}
			profile.AP = { "integerValue": AP.value}
			print(profile)
			Firebase.save_document("users?documentId=%s" % Firebase.username, profile, http)
		false:
			profile.overallScore = { "integerValue": int(overallScore.text) }
			Firebase.update_document("users/%s" % Firebase.username, profile, http)
	information_sent = true


func set_profile(value: Dictionary) -> void:
	profile = value
	nickname.text = profile.nickname.stringValue
	character_class.text = profile.character_class.stringValue
	HP.value = int(profile.HP.integerValue)
	AP.value = int(profile.AP.integerValue)
	overallScore.text = str(profile.overallScore.integerValue)
	
func fetchExistingProfiel():
	nickname.text = Firebase.profile.nickname.stringValue
	character_class.text = Firebase.profile.character_class.stringValue
	HP.value = int(Firebase.profile.HP.integerValue)
	AP.value = int(Firebase.profile.AP.integerValue)
	overallScore.text = str(Firebase.profile.overallScore.integerValue)

func _on_Button_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")