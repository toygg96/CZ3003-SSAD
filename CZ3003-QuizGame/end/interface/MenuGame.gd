extends TextureRect

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $VBoxMain/VBoxGreeting/LabelName
onready var createLevelBtn = $VBoxMain/VBoxContainer/HBoxMenu/VBoxContainer/CreateLevel
onready var summaryReportBtn = $VBoxMain/VBoxContainer/HBoxMenu/VBoxContainer/SummaryReport

var profile := {
	"nickname": {},
	"character_class": {},
	"HP": {},
	"AP": {},
	"W1Score": {},
	"W1L1Score": {},
	"W1L2Score": {},
	"W1L3Score": {},
	"W2Score": {},
	"W2L1Score": {},
	"W2L2Score": {},
	"W2L3Score": {},
	"W3Score": {},
	"W3L1Score": {},
	"W3L2Score": {},
	"W3L3Score": {},
	"W4Score": {},
	"W4L1Score": {},
	"W4L2Score": {},
	"W4L3Score": {},
	"W5Score": {},
	"W5L1Score": {},
	"W5L2Score": {},
	"W5L3Score": {},
	"upPoints": {},
	"overallScore": {}
} setget set_profile

func set_profile(value: Dictionary) -> void:
	profile = value
	Firebase.profile=profile
	username.text = "Welcome " + profile.nickname.stringValue
	
func _ready() -> void:
	Firebase.get_document("users/%s" % Firebase.username, http)
	if(Firebase.username == "teacher"):
		createLevelBtn.set_text("CREATE ASSIGNMENT")
	else:
		summaryReportBtn.hide()

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			print("Profile not found")
			Firebase.new_character = true
			get_tree().change_scene("res://interface/profile/UserProfile.tscn")
		200:
			self.profile = result_body.fields
			Firebase.profile = result_body.fields

func _on_Quit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	return get_tree().change_scene("res://interface/screen_credits.tscn")
	
func _on_Profile_pressed():
	return get_tree().change_scene("res://interface/profile/UserProfile.tscn")

func _on_CreateLevel_pressed():
	return get_tree().change_scene("res://interface/assignment/CreateAssignment.tscn")

func _on_StartGame_pressed():
	return get_tree().change_scene("res://interface/world/world.tscn")

func _on_Signout_pressed():
	get_tree().change_scene("res://interface/login/Login.tscn")

func _on_Upgrade_Character_pressed():
	Firebase.upgrade_character = true
	return get_tree().change_scene("res://interface/profile/UserProfile.tscn")

func _on_Leaderboards_pressed():
	return get_tree().change_scene("res://interface/leaderboard/leaderboard.tscn")
	
func _on_SummaryReport_pressed():
	return get_tree().change_scene("res://interface/summaryreport/Summary.tscn")
