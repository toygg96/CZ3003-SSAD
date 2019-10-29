extends TextureRect

onready var http : HTTPRequest = $HTTPRequest
onready var player_name_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/LabelPlayerName")
onready var quiz_number_node = get_node("Panel/VBoxContainer/HBoxConfirm/Panel2/quiz_number")
onready var text_panel_node = get_node("Panel/VBoxContainer/HBoxQuestion/TextPanel")
onready var inner_text_panel_node = text_panel_node.get_node("Panel")
onready var quiz_node = inner_text_panel_node.get_node("QuizText")
onready var media_panel_node = get_node("Panel/VBoxContainer/HBoxQuestion/MediaPanel")
onready var media_node = media_panel_node.get_node("Panel/TextureRect")
onready var confirm_button = get_node("Panel/VBoxContainer/HBoxConfirm/Confirm")
onready var next_button = get_node("Panel/VBoxContainer/HBoxConfirm/Next")
onready var quit_button = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxInfo/HBoxScore/HBoxQuit/VBoxQuit/ButtonQuit")
onready var player_wrong = get_node("PlayerWrong")
onready var player_correct = get_node("PlayerCorrect")
onready var score_label_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxInfo/HBoxScore/PlayerScoreLabel")
onready var AP_bar = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxInfo/AP/APBar")
onready var answer_panel_1_node = get_node("Panel/VBoxContainer/HBoxAnswers1/Panel")
onready var answer_panel_2_node = get_node("Panel/VBoxContainer/HBoxAnswers1/Panel2")
onready var answer_panel_3_node = get_node("Panel/VBoxContainer/HBoxAnswers2/Panel")
onready var answer_panel_4_node = get_node("Panel/VBoxContainer/HBoxAnswers2/Panel2")
onready var questionNum = 1
onready var teacherToken = "7FlV5gLCeBTYuGnvLd0k0W1dHps2"
onready var teacherTokenBool = true

onready var answer_nodes = [
answer_panel_1_node.get_node("Panel/VBoxContainer/Answer1"),
answer_panel_2_node.get_node("Panel/VBoxContainer/Answer2"),
answer_panel_3_node.get_node("Panel/VBoxContainer/Answer3"),
answer_panel_4_node.get_node("Panel/VBoxContainer/Answer4")
]

onready var gamepad_hints = [
answer_panel_1_node.get_node("Panel/VBoxContainer/HBoxContainer/LabelGamepadHint"),
answer_panel_2_node.get_node("Panel/VBoxContainer/HBoxContainer/LabelGamepadHint"),
answer_panel_3_node.get_node("Panel/VBoxContainer/HBoxContainer/LabelGamepadHint"),
answer_panel_4_node.get_node("Panel/VBoxContainer/HBoxContainer/LabelGamepadHint")
]
onready var lifes_idx = 0;
onready var AP_idx = 0;
onready var Wscore = 0;
onready var Oscore = 0;
onready var UPoints = 0;
onready var wstring = "W%sScore"%int(Firebase.worldSelected)
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
	"upPoints": {},
	"overallScore": {}
} setget set_profile

#var lifes_idx = int(Firebase.profile.HP.integerValue)
#var AP_idx = Firebase.get_document("users/%s" %Firebase.username,http).AP.integerValue
var score = 0
var ACost = int(Firebase.worldSelected)
onready var life_nodes = [
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life1"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life2"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life3"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life4"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life5")
]

onready var life_empty = load("res://styles/life_empty.tres")
onready var life_full = load("res://styles/life_full.tres")
onready var life_dfull = load("res://styles/life_dfull.tres")
onready var life_tfull = load("res://styles/life_tfull.tres")
onready var answer_selected = load("res://styles/dark_answer_selected.tres") 
onready var answer_inner = load("res://styles/dark_inner.tres") 
onready var answer_correct = load("res://styles/answer_correct.tres")
onready var answer_missed = load("res://styles/answer_missed.tres")
onready var answer_error = load("res://styles/answer_error.tres")
onready var style_opponent_has_answer = load("res://styles/answer_missed.tres")

# Setup parameters
var language_id
var need_next_button = false

# Gameplay parameters
var session_id = 0
var quizzes = []
var current_quiz_idx = 0
var current_quiz_question = {}
var player_id = -1
var answer_accepted = false
var answer_ids = [0, 0, 0, 0]
var answer_selection = [false, false, false, false]
var correct_answers = [false, false, false, false]
var answer_result_timeout = 0
var allow_next = true
var disableInput = false

var new_question = false
var information_sent := false
var question := {
	"question": {},
	"answer1": {},
	"answer2": {},
	"answer3": {},
	"answer4": {},
	"correctAns": {}
} setget set_question

func _ready():
	_generate_player_life(lifes_idx)
	fetchExistingProfiel()
	AP_bar.max_value = AP_idx
	AP_bar.value = AP_idx
	print(Firebase.user_info.id);
	Firebase.get_document("worlds/%s" % teacherToken + "/" +  Firebase.worldSelected + "/" + Firebase.difficultySelected + "/qns/" + ("Q"+str(questionNum)) , http)

func _on_ButtonQuit_pressed():
	get_tree().change_scene("res://interface/MenuGame.tscn")

func _generate_player_life_all(t: int)->void:
	if t == 1:
		for i in range(5):
			life_nodes[i].set("custom_styles/panel", life_full)
		return
	elif t == 2:
		for i in range(5):
			life_nodes[i].set("custom_styles/panel", life_dfull)
		return
	for i in range(5):
		life_nodes[i].set("custom_styles/panel", life_tfull)
	return
	
func _generate_player_life(life: int)->void:
	var lchange = life%5
		
	if life <= 5:
		_generate_player_life_all(1)
		if lchange == 0:
			return
		for i in range(5-lchange):
			life_nodes[lchange].set("custom_styles/panel", life_empty)
			lchange+=1
		return
		
	elif life <= 10:
		_generate_player_life_all(2)
		if lchange == 0:
			return
		for i in range(lchange):
			life_nodes[lchange-1].set("custom_styles/panel", life_full)
			lchange-=1
		return
	for i in range(5):
		_generate_player_life_all(3)
		if lchange == 0:
			return
		for i in range(lchange):
			life_nodes[lchange-1].set("custom_styles/panel", life_dfull)
		return	 
		

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	match response_code:
		404:
			print("No record found")
			new_question = true
			teacherToken = Firebase.user_info.id
			questionNum = 1
			next_button.hide()
			if teacherTokenBool == false:
				#http.set_use_threads(true)
				_updateProfile()
			else:
				for i in [0,1,2,3]:
					clear_answers(i)
				Firebase.get_document("worlds/%s" % teacherToken + "/" +  Firebase.worldSelected + "/" + Firebase.difficultySelected + "/qns/" + ("Q"+str(questionNum)) , http)
				teacherTokenBool = false
				return
		400:
			print("HTTP 400")
		200:
			if information_sent:
				print("Information saved successfully")
				information_sent = false
				_on_ButtonQuit_pressed()
			else:
				self.question = result_body.fields

func set_question(value: Dictionary) -> void:
	question = value
	quiz_node.text = question.question.stringValue
	answer_nodes[0].text = question.answer1.stringValue
	answer_nodes[1].text = question.answer2.stringValue
	answer_nodes[2].text = question.answer3.stringValue
	answer_nodes[3].text = question.answer4.stringValue

func highlight_answer(answer_node, style):
	answer_node.get_parent().get_parent().set("custom_styles/panel", style)

func _on_Answer1_gui_input(ev):
	match disableInput:
		true:
			pass
		false:
			checkAnswer(ev,1)
	
func _on_Answer2_gui_input(ev):
	match disableInput:
		true:
			pass
		false:
			checkAnswer(ev,2)
	
func _on_Answer3_gui_input(ev):
	match disableInput:
		true:
			pass
		false:
			checkAnswer(ev,3)
		
func _on_Answer4_gui_input(ev):
	match disableInput:
		true:
			pass
		false:
			checkAnswer(ev,4)

func checkAnswer(ev,num):
	if (ev is InputEventMouseMotion):
		pass
	elif (ev is InputEventMouseButton) and ev.pressed and question.correctAns.stringValue == "Answer" + str(num):
		player_correct.play()
		highlight_answer(answer_nodes[num-1],answer_correct)
		print("Answer" + str(num) + " is selected and its correct")
		disableInput = true
		next_button.show()
		score += 1000
		score_label_node.text = str(score)
		_consume_AP(AP_idx)
	elif (ev is InputEventScreenTouch) and ev.pressed and question.correctAns.stringValue == "Answer" + str(num):
		player_correct.play()
		highlight_answer(answer_nodes[num-1],answer_correct)
		print("Answer" + str(num) + " is selected and its correct")
		disableInput = true
		next_button.show()
		score += 1000
		score_label_node.text = str(score)
		_consume_AP(AP_idx)
	else:
		player_wrong.play()
		highlight_answer(answer_nodes[num-1],answer_error)
		var i = int(question.correctAns.stringValue[6])
		highlight_answer(answer_nodes[i-1],answer_correct)
		disableInput = true
		_damage(lifes_idx)
		lifes_idx-=1
		_consume_AP(AP_idx)
		if lifes_idx<=0:
			_on_ButtonQuit_pressed()
		next_button.show()	
	
func _consume_AP(cAP: int)->void:
	if cAP >= ACost:
		AP_idx -= ACost
		AP_bar.value = AP_idx
		return
	_on_ButtonQuit_pressed()
	
func _damage(life: int)->void:
	var dchange=life%5
	if life >= 11:
		life_nodes[dchange-1].set("custom_styles/panel", life_dfull)
		return
	elif life >= 6:
		life_nodes[dchange-1].set("custom_styles/panel", life_full)
		return
	life_nodes[dchange-1].set("custom_styles/panel", life_empty)
	return
	
func clear_answers(num):
	highlight_answer(answer_nodes[num], answer_inner)

func clear_questionsAnswers():
	quiz_node.set_text("")
	for i in [0,1,2,3]:
		answer_nodes[i].set_text("")

func _on_Next_pressed():
	if AP_idx == 0:
		_on_ButtonQuit_pressed()
	
	questionNum = questionNum + 1
	print("questionNum: Q" + str(questionNum))
	Firebase.get_document("worlds/%s" % teacherToken + "/" +  Firebase.worldSelected + "/" + Firebase.difficultySelected + "/qns/" + ("Q"+str(questionNum)) , http)
	disableInput = false
	next_button.hide()
	for i in [0,1,2,3]:
		clear_answers(i)

func set_profile(value: Dictionary) -> void:
	profile = value
	lifes_idx = int(Firebase.profile.HP.integerValue)
	AP_idx = int(Firebase.profile.AP.integerValue)
	Wscore = int(Firebase.profile.wstring.integerValue)
	Oscore = int(Firebase.profile.overallScore.integerValue)
	UPoints = int(Firebase.profile.upPoints.integerValue)

func fetchExistingProfiel():
	lifes_idx = int(Firebase.profile.HP.integerValue)
	AP_idx = int(Firebase.profile.AP.integerValue)
	Wscore = int(Firebase.profile.get(wstring).integerValue) 
	Oscore = int(Firebase.profile.overallScore.integerValue)
	UPoints = int(Firebase.profile.upPoints.integerValue)
	
func _updateProfile():
	if score > Wscore:
		Oscore = Oscore - Wscore + score
		UPoints += score - Wscore
		if int(Firebase.worldSelected) == 1:
			Firebase.profile.W1Score = { "integerValue": score }
		elif int(Firebase.worldSelected) == 2:
			Firebase.profile.W2Score = { "integerValue": score }
		elif int(Firebase.worldSelected) == 3:
			Firebase.profile.W3Score = { "integerValue": score }
		elif int(Firebase.worldSelected) == 4:
			Firebase.profile.W4Score = { "integerValue": score }
		elif int(Firebase.worldSelected) == 5:
			Firebase.profile.W5Score = { "integerValue": score }
		Firebase.profile.overallScore = { "integerValue": Oscore }
		Firebase.profile.upPoints = { "integerValue": UPoints }
		Firebase.update_document("users/%s" % Firebase.username, Firebase.profile , http)
		print(Firebase.profile)
	information_sent = true

func set_quiz(question):
	quizzes = question

func get_quiz():
	return quizzes