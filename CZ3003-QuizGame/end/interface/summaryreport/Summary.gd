extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var notification = get_node("Score container/scores/report")
onready var search_input = get_node("Score container/searchbar/SearchInput")

var user_list = []
var defaultText = ""

func _ready():
	Firebase.get_document("users/" , http)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary

	match response_code:
		404:
			notification.text = "Please, enter your information"
			return
		200:
			for user in result_body.documents:
				if user.fields.nickname.stringValue == "teacher":
					continue
				
				user_list.append(user)
				
			generate_scores(user_list)
			
func generate_scores(user_list):
	var score_list = []

	score_list = compute_total_scores(user_list)

	score_list[0] = gen_average_score(score_list[0], user_list.size())
	score_list[1] = gen_average_score(score_list[1], user_list.size())
	score_list[2] = gen_average_score(score_list[2], user_list.size())
	score_list[3] = gen_average_score(score_list[3], user_list.size())
	score_list[4] = gen_average_score(score_list[4], user_list.size())
	score_list[5] = gen_average_score(score_list[5], user_list.size())
	score_list[6] = gen_average_score(score_list[6], user_list.size())
	
	defaultText = "Average Overall Score: " + str(score_list[0]) + "\nAverage World 1 Score: " + str(score_list[1]) + "\nAverage World 2 Score: " + str(score_list[2]) + "\nAverage World 3 Score: " + str(score_list[3]) + "\nAverage World 4 Score: " + str(score_list[4]) + "\nAverage World 5 Score: " + str(score_list[5]) + "\nAverage World 6 Score: " + str(score_list[6])
	notification.text = defaultText
	
func compute_total_scores(user_list):
	var w1_score = 0
	var w2_score = 0
	var w3_score = 0
	var w4_score = 0
	var w5_score = 0
	var w6_score = 0
	var overall_score = 0
	
	for user in user_list:
		overall_score += int(user.fields.overallScore.integerValue)
		w1_score += int(user.fields.W1Score.integerValue)
		w2_score += int(user.fields.W2Score.integerValue)
		w3_score += int(user.fields.W3Score.integerValue)
		w4_score += int(user.fields.W4Score.integerValue)
		w5_score += int(user.fields.W5Score.integerValue)
		w6_score += int(user.fields.W6Score.integerValue)
		
	return [overall_score, w1_score, w2_score, w3_score, w4_score, w5_score, w6_score]
	
func gen_average_score(score, length):
	return score / length
	
func _on_search_button_pressed():
	var username = ""
	for user in user_list:
		username = user.name.split("/")[6]
		if search_input.text != username:
			continue
			
		# If user is in the list, display info and exit from function
		notification.text = "User: " + username + "\nNickname: " + user.fields.nickname.stringValue + "\nWorld 1 Score: " + user.fields.W1Score.integerValue + "\nWorld 2 Score:" + user.fields.W2Score.integerValue + "\nWorld 3 Score:" + user.fields.W3Score.integerValue + "\nWorld 4 Score:" + user.fields.W4Score.integerValue + "\nWorld 5 Score:" + user.fields.W5Score.integerValue + "\nWorld 6 Score:" + user.fields.W6Score.integerValue
		return
	
	# If user not found
	notification.text = "User does not exist"
		
func _on_SearchInput_text_changed(new_text):
	if new_text.length() == 0:
		notification.text = defaultText
		
func _on_back_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")

