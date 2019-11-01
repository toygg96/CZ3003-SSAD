extends Node

# Declare member variables here. Examples:
onready var http : HTTPRequest = $HTTPRequest
onready var http2 : HTTPRequest = $HTTPRequest2
onready var http3 : HTTPRequest = $HTTPRequest3
onready var socialMediaPopup = $socialMediaPopup
onready var title = $Container/Title
onready var question : Label = $Container/VBoxContainer2/Question/LineEdit
onready var answer1 : Label = $Container/VBoxContainer2/Answer1/LineEdit
onready var notification : Label = $Container/Notification
onready var answer2 : Label = $Container/VBoxContainer2/Answer2/LineEdit
onready var answer3 : Label = $Container/VBoxContainer2/Answer3/LineEdit
onready var answer4 : Label = $Container/VBoxContainer2/Answer4/LineEdit
onready var dropdown : OptionButton  = $Container/VBoxContainer2/HBoxContainer2/Dropdown
onready var itemSelected
onready var questionNumSelected
onready var questionNumDropdown : OptionButton  = $Container/VBoxContainer2/Selections/QuestionNumDropdown

var socialMediaMode
var createQnsCollection = false
var new_question := false
var information_sent := false
var questionObj := {
	"question": {},
	"answer1": {},
	"answer2": {},
	"answer3": {},
	"answer4": {},
	"correctAns": {}
} setget set_questionObj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Firebase.get_document("custom/%s" % Firebase.username, http)
	add_items()
	add_questionItems()
	if(Firebase.username == "teacher"):
		title.set_text("Create Assignment")
	else:
		title.set_text("Create Level")

func _on_Button_pressed():
	get_tree().change_scene("res://interface/MenuGame.tscn")

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print("response  code[EXISTING RECORD]: " , response_code)
	match response_code:
		404:
			notification.text = "No record found"
			new_question = true
			clear_all()
			add_items()
			itemSelected = "NULL"
			return
		400:
			notification.text = "HTTP 400 Correct ans is null. Status: INVALID_ARGUMENT" 
		409:
			if(!(createQnsCollection)):
				notification.text = "No changes were made" 
		200:
			if information_sent:
				notification.text = "Information saved successfully"
				information_sent = false
	
			else :
				notification.text = "Information retrieved successfully"			
				self.questionObj = result_body.fields	
			new_question = false
		
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	print("response  code[FB]: " , response_code)
	match response_code:
		404:
			notification.text = "Post to FB failed"
		200:
			notification.text = "Successfully posted to FB"

func _on_HTTPRequest3_request_completed(result, response_code, headers, body):
	print("response  code[TWITTER]: " , response_code)
	print(body.get_string_from_ascii())
	match response_code:
		404:
			notification.text = "Post to Twitter failed"
		200:
			notification.text = "Successfully posted to Twitter"

func _on_ConfirmButton_pressed() -> void:
	if question.text.empty() or answer1.text.empty() or answer2.text.empty() or answer3.text.empty() or answer4.text.empty() or itemSelected == "NULL":
		notification.text = "Please, enter the question and answers"
		return
	questionObj.question = { "stringValue": question.text }
	questionObj.answer1 = { "stringValue": answer1.text }
	questionObj.answer2 = { "stringValue": answer2.text }
	questionObj.answer3 = { "stringValue": answer3.text }
	questionObj.answer4 = { "stringValue": answer4.text }
	questionObj.correctAns = { "stringValue": itemSelected } 
	match new_question:
		true:
			print(Firebase.username)
			information_sent = true
			Firebase.save_document("custom/?documentId=%s" % Firebase.username, {},http)
			createQnsCollection = true
			yield(get_tree().create_timer(1.0), "timeout")
			Firebase.save_document("custom/%s" % Firebase.username + "/qns/?documentId=%s" % questionNumSelected, questionObj, http)
			createQnsCollection = false
			yield(get_tree().create_timer(1.2), "timeout")
			socialMediaMode = "created"	
			print(information_sent)
		false:
			print(questionObj.correctAns)
			information_sent = true
			Firebase.update_document("custom/%s" % Firebase.username + "/qns/%s" % questionNumSelected , questionObj, http)
			yield(get_tree().create_timer(1.2), "timeout")
			#Firebase.generate_fb_link(http2,"updated")
			socialMediaMode = "updated"
	socialMediaPopup.show()

func set_questionObj(value: Dictionary) -> void:
	questionObj = value
	clear_all()
	question.text = questionObj.question.stringValue
	answer1.text = questionObj.answer1.stringValue
	answer2.text = questionObj.answer2.stringValue
	answer3.text = questionObj.answer3.stringValue
	answer4.text = questionObj.answer4.stringValue
	itemSelected = questionObj.correctAns.stringValue
	dropdown.add_item(questionObj.correctAns.stringValue)
	dropdown.add_separator()
	for i in [1,2,3,4]:
		if i == int(questionObj.correctAns.stringValue[6]):
			pass
		else :
			dropdown.add_item("Answer" + str(i))
	
func add_items():
	 dropdown.add_item("NULL")
	 dropdown.add_separator()
	 dropdown.add_item("Answer1")
	 dropdown.add_item("Answer2")
	 dropdown.add_item("Answer3")
	 dropdown.add_item("Answer4")
	
func clear_all():
	dropdown.clear()
	question.clear()
	answer1.clear()
	answer2.clear()
	answer3.clear()
	answer4.clear()

func _on_Dropdown_item_selected(ID):
	itemSelected = dropdown.get_item_text(ID)

func _on_fbBtn_pressed():
	Firebase.generate_fb_link(http2, socialMediaMode)
	yield(get_tree().create_timer(1.8), "timeout")
	socialMediaPopup.hide()

func _on_twitterBtn_pressed():
	Firebase.generate_twitter_link(http3, socialMediaMode)
	yield(get_tree().create_timer(1.8), "timeout")
	socialMediaPopup.hide()
	
func _on_closeBtn_pressed():
	socialMediaPopup.hide()

func add_questionItems():
	 questionNumDropdown.add_item("QN")
	 questionNumDropdown.add_separator()
	 questionNumDropdown.add_item("Q1")
	 questionNumDropdown.add_item("Q2")
	 questionNumDropdown.add_item("Q3")
	 questionNumDropdown.add_item("Q4")
	 questionNumDropdown.add_item("Q5")
	
func _on_QuestionNumDropdown_item_selected(ID):
	questionNumSelected = questionNumDropdown.get_item_text(ID)
	Firebase.get_document("custom/" + Firebase.username + "/qns/" + questionNumSelected, http)
	notification.text = "Please choose a difficulty"
