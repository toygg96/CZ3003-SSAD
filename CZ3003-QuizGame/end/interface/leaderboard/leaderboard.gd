extends Node

onready var http : HTTPRequest = $HTTPRequest
onready var notification : Label = $VBoxContainer2/ranking
onready var title : Label = $VBoxContainer/Label

var count = 0
var user = []
var profile := {
	"nickname": {},
	"character_class": {},
	"strength": {},
	"intelligence": {},
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
				if (profile.nickname.stringValue != "GodMode") :
					print("Correct username: " + profile.nickname.stringValue)
					user.append(profile)
			bubbleSortRankings()
			while(count < 10):
				if(count == (user.size())):
					print(count)
					return
				else:
					print(user[count]["nickname"]["stringValue"])
					print(user[count]["overallScore"]["integerValue"])
					notification.text = notification.text + user[count]["nickname"]["stringValue"] + "\t " + str(user[count]["overallScore"]["integerValue"] + "\n")
					count+=1

func bubbleSortRankings():
	for i in range(user.size()-1, -1, -1):
 		 for j in range(1,i+1,1):
		    if (user[j]["overallScore"]["integerValue"] > user[j-1]["overallScore"]["integerValue"]):
      			var temp = user[j]
	      		user[j] = user[j-1]
	      		user[j-1] = temp

func _on_back_pressed():
	return get_tree().change_scene("res://interface/MenuGame.tscn")
