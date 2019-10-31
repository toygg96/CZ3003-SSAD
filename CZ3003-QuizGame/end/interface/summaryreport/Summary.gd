extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var notification = get_node("Score container/scores/report")
onready var search_input = get_node("Score container/searchbar/SearchInput")

var user_list = []
var average_overall_score = 0
var average_w1_score = 0
var average_w2_score = 0
var average_w3_score = 0
var average_w4_score = 0
var average_w5_score = 0
var average_w6_score = 0
var defaultText = ""
var profile = {} 

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
				
				profile = user
				
				user_list.append(profile)
				
			# print(user_list)
			generate_scores()
			
func generate_scores():
	for user in user_list:
		average_overall_score += int(user.fields.overallScore.integerValue)
		average_w1_score += int(user.fields.W1Score.integerValue)
		average_w2_score += int(user.fields.W2Score.integerValue)
		average_w3_score += int(user.fields.W3Score.integerValue)
		average_w4_score += int(user.fields.W4Score.integerValue)
		average_w5_score += int(user.fields.W5Score.integerValue)
		average_w6_score += int(user.fields.W6Score.integerValue)
	
	average_overall_score /= user_list.size()
	average_w1_score /= user_list.size()
	average_w2_score /= user_list.size()
	average_w3_score /= user_list.size()
	average_w4_score /= user_list.size()
	average_w5_score /= user_list.size()
	average_w6_score /= user_list.size()
	
	defaultText = "Average Overall Score: " + str(average_overall_score) + "\nAverage World 1 Score: " + str(average_w1_score) + "\nAverage World 2 Score: " + str(average_w2_score) + "\nAverage World 3 Score: " + str(average_w3_score) + "\nAverage World 4 Score: " + str(average_w4_score) + "\nAverage World 5 Score: " + str(average_w5_score) + "\nAverage World 6 Score: " + str(average_w6_score)
	notification.text = defaultText
	
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

