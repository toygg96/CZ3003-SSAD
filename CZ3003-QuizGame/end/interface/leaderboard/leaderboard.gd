extends Node

onready var http : HTTPRequest = $HTTPRequest
onready var notification : Label = $VBoxContainer/VBoxContainer3/VBoxContainer2/ranking
onready var title : Label = $VBoxContainer/Label

var count = 0
var user = []
var profile := {
	"nickname": {},
	"character_class": {},
	"overallScore": {}
} 

func _ready():
	Firebase.get_document("users/" , http)
	pass

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	#print(result_body)
	match response_code:
		404:
			notification.text = "Please, enter your information"
			return
		200:
			for users in result_body.documents:
				profile = users.fields
<<<<<<< HEAD
				# print(users.fields)
				if (profile.nickname.stringValue != "GodMode") :
					# print("Correct username: " + profile.nickname.stringValue)
=======
				if (profile.nickname.stringValue != "teacher") :
>>>>>>> 5af434620d9ec7922c0385519acb0fcc98b49521
					user.append(profile)
			bubbleSortRankings()
			while(count < 10):
				if(count == (user.size())):
					# print(count)
					return
				else:
					#print(user[count]["nickname"]["stringValue"])
					#print(user[count]["overallScore"]["integerValue"])
					notification.text = notification.text + user[count]["nickname"]["stringValue"] + "\t " + str(user[count]["overallScore"]["integerValue"] + "\n")
					count+=1

func bubbleSortRankings():
<<<<<<< HEAD
	for i in range(user.size()-1, -1, -1):
		for j in range(1,i+1,1):
			if (user[j]["overallScore"]["integerValue"] > user[j-1]["overallScore"]["integerValue"]):
      			var temp = user[j]
	      		user[j] = user[j-1]
	      		user[j-1] = temp
=======
	for i in range(user.size()-1, -1, -1):	
		for j in range(1,i+1,1):
			var tempAScoreValue = int(user[j]["overallScore"]["integerValue"])
			var tempBScoreValue = int(user[j-1]["overallScore"]["integerValue"])
			if(tempAScoreValue > tempBScoreValue):
				var temp = user[j-1]
				user[j-1] = user[j]
				user[j] = temp
>>>>>>> 5af434620d9ec7922c0385519acb0fcc98b49521

func _on_back_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")
