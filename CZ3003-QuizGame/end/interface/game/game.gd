extends TextureRect

onready var http : HTTPRequest = $HTTPRequest
onready var player_name_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/LabelPlayerName")
onready var opponent_lives_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives")
onready var opponent_name_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/LabelOpponentName")
onready var category_node = get_node("Panel/VBoxContainer/HBoxConfirm/Panel/category")
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
onready var opponent_score_label_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxInfo/HBoxScore/OpponentScoreLabel")
onready var timer_progress_node = get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxInfo/HBoxTimer")
onready var label_reward_node = timer_progress_node.get_node("LabelReward")
onready var timer_progress_bar_node = timer_progress_node.get_node("ProgressBar")
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

onready var life_nodes = [
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life1"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life2"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life3"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life4"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxPlayerLives/HBoxLives/Life5")
]
var lifes_idx = 5
var score = 0

onready var opponent_life_nodes = [
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/HBoxLives/Life1"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/HBoxLives/Life2"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/HBoxLives/Life3"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/HBoxLives/Life4"),
get_node("Panel/VBoxContainer/PanelLives/HBoxLives/VBoxOpponentLives/HBoxLives/Life5")
]
var opponent_lifes_idx = 0
var opponent_score = 0

onready var life_empty = load("res://styles/life_empty.tres")
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
var opponent_ready = false
var player_id = -1
var opponent_player_id = -1
var answer_accepted = false
var opponent_answer_present = false
var opponent_answer_accepted = false
var answer_ids = [0, 0, 0, 0]
var answer_selection = [false, false, false, false]
var opponent_answer_selection = [false, false, false, false] # will be updated in has_opponent_answer()
var correct_answers = [false, false, false, false]
var cpu_opponent_progress_threshold = 0
var answer_result_timeout = 0
var allow_next = true
var opponent_lost = false
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
	print(Firebase.user_info.id);
	Firebase.get_document("worlds/%s" % teacherToken + "/" +  Firebase.worldSelected + "/" + Firebase.difficultySelected + "/qns/" + ("Q"+str(questionNum)) , http)

func _on_ButtonQuit_pressed():
	get_tree().change_scene("res://interface/MenuGame.tscn")
	
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
				Firebase.profile.overallScore = { "integerValue": score }
				Firebase.update_document("users/%s" % Firebase.username, Firebase.profile , http)
				information_sent = true
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
	elif (ev is InputEventScreenTouch) and ev.pressed and question.correctAns.stringValue == "Answer" + str(num):
		player_correct.play()
		highlight_answer(answer_nodes[num-1],answer_correct)
		print("Answer" + str(num) + " is selected and its correct")
		disableInput = true
		next_button.show()
		score += 1000
		score_label_node.text = str(score)
	else:
		player_wrong.play()
		highlight_answer(answer_nodes[num-1],answer_error)
		var i = int(question.correctAns.stringValue[6])
		highlight_answer(answer_nodes[i-1],answer_correct)
		disableInput = true
		next_button.show()	
	
func clear_answers(num):
	highlight_answer(answer_nodes[num], answer_inner)

func clear_questionsAnswers():
	quiz_node.set_text("")
	for i in [0,1,2,3]:
		answer_nodes[i].set_text("")

func _on_Next_pressed():
	questionNum = questionNum + 1
	print("questionNum: Q" + str(questionNum))
	Firebase.get_document("worlds/%s" % teacherToken + "/" +  Firebase.worldSelected + "/" + Firebase.difficultySelected + "/qns/" + ("Q"+str(questionNum)) , http)
	disableInput = false
	next_button.hide()
	for i in [0,1,2,3]:
		clear_answers(i)
