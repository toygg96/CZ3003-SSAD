extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var back_button = $Container/VBoxContainer2/HBoxContainer/HBoxContainer2/BackButton
onready var confirm_button = $Container/VBoxContainer2/HBoxContainer/HBoxContainer/ConfirmButton
onready var title : Label = $Container/Title
onready var nickname : Label = $Container/VBoxContainer2/Name/LineEdit
onready var character_class_title = $Container/VBoxContainer2/Class/Label
onready var character_class : Label = $Container/VBoxContainer2/Class/LineEdit
onready var choose_class_title = $Container/VBoxContainer2/ChooseClass/Label
onready var choose_class_container = $Container/VBoxContainer2/ChooseClass/ClassChoice
onready var notification : Label = $Container/Notification
onready var HP : Slider = $Container/VBoxContainer2/HP/HP_Slider
onready var AP : Slider = $Container/VBoxContainer2/AP/AP_Slider
onready var character = $Container/Sprite
onready var OHP = 0
onready var OAP = 0
onready var upgradeP = 0
onready var overallScore : Label = $Container/VBoxContainer2/Score/Label2

var information_sent := false
var profile := {
	"nickname": {},
	"character_class": {},
	"HP": {},
	"AP": {},
	"W1Score": {},
	"W1L1Score" : {},
	"W1L2Score" : {},
	"W1L3Score" : {},
	"W2Score": {},
	"W2L1Score" : {},
	"W2L2Score" : {},
	"W2L3Score" : {},
	"W3Score": {},
	"W3L1Score" : {},
	"W3L2Score" : {},
	"W3L3Score" : {},
	"W4Score": {},
	"W4L1Score" : {},
	"W4L2Score" : {},
	"W4L3Score" : {},
	"W5Score": {},
	"W5L1Score" : {},
	"W5L2Score" : {},
	"W5L3Score" : {},
	"W6Score" : {},
	"upPoints": {},
	"overallScore": {}
} setget set_profile

var user_character = ""

func _ready() -> void:
	if (Firebase.new_character):
		title.set_text("CREATE NEW CHARACTER")
		nickname.text = Firebase.username
		nickname.set_editable(false)
		HP.set_editable(false)
		AP.set_editable(false)
		user_character = "Mage"
		hide_class_buttons("new")
		
	elif (Firebase.upgrade_character) :
		title.set_text("UPGRADE CHARACTER")
		fetchExistingProfiel()
		HP.value = int(Firebase.profile.HP.integerValue)
		AP.value = int(Firebase.profile.AP.integerValue)
		hide_class_buttons("upgrade")
		
	else:
		title.set_text("VIEW CHARACTER")
		fetchExistingProfiel()
		HP.value = int(Firebase.profile.HP.integerValue)
		AP.value = int(Firebase.profile.AP.integerValue)
		overallScore.text = Firebase.profile.overallScore.integerValue
		nickname.set_editable(false)
		character_class.set_editable(false)
		HP.set_editable(false)
		AP.set_editable(false)
		hide_class_buttons("view")
		
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

	if(Firebase.new_character):
		#true:	
			profile.nickname = { "stringValue": Firebase.username }
			profile.character_class = { "stringValue": character_class.text }
			profile.W1Score = { "integerValue": 0}
			profile.W1L1Score = { "integerValue": 0}
			profile.W1L2Score = { "integerValue": 0}
			profile.W1L3Score = { "integerValue": 0}
			profile.W2Score = { "integerValue": 0}
			profile.W2L1Score = { "integerValue": 0}
			profile.W2L2Score = { "integerValue": 0}
			profile.W2L3Score = { "integerValue": 0}
			profile.W3Score = { "integerValue": 0}
			profile.W3L1Score = { "integerValue": 0}
			profile.W3L2Score = { "integerValue": 0}
			profile.W3L3Score = { "integerValue": 0}
			profile.W4Score = { "integerValue": 0}
			profile.W4L1Score = { "integerValue": 0}
			profile.W4L2Score = { "integerValue": 0}
			profile.W4L3Score = { "integerValue": 0}
			profile.W5Score = { "integerValue": 0}
			profile.W5L1Score = { "integerValue": 0}
			profile.W5L2Score = { "integerValue": 0}
			profile.W5L3Score = { "integerValue": 0}
			profile.W6Score = { "integerValue": 0}
			profile.upPoints = { "integerValue": 0}
			profile.overallScore = { "integerValue": 0 }
			profile.HP = { "integerValue": 5 }
			profile.AP = { "integerValue": 5 }
			print(profile)
			information_sent = true
			Firebase.save_document("users?documentId=%s" % Firebase.username, profile, http)
		#false:
	else:
			profile.nickname = { "stringValue": nickname.text }
			profile.character_class = { "stringValue": character_class.text }
			profile.HP = { "integerValue": HP.value }
			profile.AP = { "integerValue": AP.value }
			profile.W1Score = { "integerValue": Firebase.profile.W1Score.integerValue}
			profile.W1L1Score = { "integerValue": Firebase.profile.W1L1Score.integerValue}
			profile.W1L2Score = { "integerValue": Firebase.profile.W1L2Score.integerValue}
			profile.W1L3Score = { "integerValue": Firebase.profile.W1L3Score.integerValue}
			profile.W2Score = { "integerValue": Firebase.profile.W2Score.integerValue}
			profile.W2L1Score = { "integerValue": Firebase.profile.W2L1Score.integerValue}
			profile.W2L2Score = { "integerValue": Firebase.profile.W2L2Score.integerValue}
			profile.W2L3Score = { "integerValue": Firebase.profile.W2L3Score.integerValue}
			profile.W3Score = { "integerValue": Firebase.profile.W3Score.integerValue}
			profile.W3L1Score = { "integerValue": Firebase.profile.W3L1Score.integerValue}
			profile.W3L2Score = { "integerValue": Firebase.profile.W3L2Score.integerValue}
			profile.W3L3Score = { "integerValue": Firebase.profile.W3L3Score.integerValue}
			profile.W4Score = { "integerValue": Firebase.profile.W4Score.integerValue}
			profile.W4L1Score = { "integerValue": Firebase.profile.W4L1Score.integerValue}
			profile.W4L2Score = { "integerValue": Firebase.profile.W4L2Score.integerValue}
			profile.W4L3Score = { "integerValue": Firebase.profile.W4L3Score.integerValue}
			profile.W5Score = { "integerValue": Firebase.profile.W5Score.integerValue}
			profile.W5L1Score = { "integerValue": Firebase.profile.W5L1Score.integerValue}
			profile.W5L2Score = { "integerValue": Firebase.profile.W5L2Score.integerValue}
			profile.W5L3Score = { "integerValue": Firebase.profile.W5L3Score.integerValue}
			profile.W6Score = { "integerValue": Firebase.profile.W6Score.integerValue}
			profile.upPoints = { "integerValue": upgradeP }
			profile.overallScore = { "integerValue": Firebase.profile.overallScore.integerValue }
			information_sent = true
			Firebase.upgrade_character = false
			print(profile)
			Firebase.update_document("users/%s" % Firebase.username, profile, http)
			#get_tree().change_scene("res://interface/MenuGame.tscn")


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
	print(Firebase.profile.HP.integerValue)
	AP.value = int(Firebase.profile.AP.integerValue)
	print(Firebase.profile.AP.integerValue)
	OHP = int(Firebase.profile.HP.integerValue)
	OAP = int(Firebase.profile.AP.integerValue)
	upgradeP = int(Firebase.profile.upPoints.integerValue)
	overallScore.text = str(Firebase.profile.upPoints.integerValue)
	load_sprite(character_class)
	
func load_sprite(character_class):
	if character_class.text == "Mage":
		set_sprite("Mage")
	
	elif character_class.text == "Warrior":
		set_sprite("Warrior")
	
	else:
		set_sprite("???")

func _on_Button_pressed():
	Firebase.upgrade_character = false
	return get_tree().change_scene("res://interface/MenuGame.tscn")

func _on_HP_Slider_value_changed(value):
	if HP.value >= OHP:
		if upgradeP < 500:
			HP.value = OHP
			return
		else:
			upgradeP -= 500
			OHP = HP.value
			overallScore.text = str(upgradeP)
			return
	elif HP.value <= OHP:
		upgradeP += 500	
		OHP = HP.value
		overallScore.text = str(upgradeP)
	

func _on_AP_Slider_value_changed(value):
	if AP.value >= OAP:
		if upgradeP < 1000:
			AP.value = OAP
			return
		else:
			upgradeP -= 1000
			OAP = AP.value
			overallScore.text = str(upgradeP)
			return
	elif AP.value <= OAP:
		upgradeP += 1000
		OAP = AP.value
		overallScore.text = str(upgradeP)
		
func hide_class_buttons(type):
	if type == "new":
		character_class_title.hide()
		character_class.hide()
		back_button.hide()
		HP.hide()
		AP.hide()
		var HP_title = get_node("Container/VBoxContainer2/HP/Label").hide()
		var AP_title = get_node("Container/VBoxContainer2/AP/Label").hide()
		var score_title = get_node("Container/VBoxContainer2/Score/Label").hide()
		
	elif type == "upgrade":
		choose_class_container.hide()
		choose_class_title.hide()
		
	else:
		character_class_title.hide()
		character_class.hide()
		confirm_button.hide()

func _on_mage_button_pressed():
	var job = "Mage"
	set_sprite(job)
	character_class.text = job

func _on_knight_button_pressed():
	var job = "Warrior"
	set_sprite(job)
	character_class.text = job
	
func set_sprite(character_class):
	if character_class == "Mage":
		character.set_texture(load("res://backgrounds/mage_idle.png"))
	
	elif character_class == "Warrior":
		character.set_texture(load("res://backgrounds/warrior_idle.png"))
		
	else:
		character.set_texture(load("res://backgrounds/rouge_idle.png"))
