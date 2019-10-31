extends Node

const API_KEY := "AIzaSyAv1kf80Njt5hTognnQjLjewWLP8tPTFso"
const PROJECT_ID := "ssadquiz"

const REGISTER_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=%s" % API_KEY
const LOGIN_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=%s" % API_KEY
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
const FB_URL := "https://graph.facebook.com/v4.0/108881370543869/feed?&access_token=EAAF6NXFLmHoBAEqbVPgGMiXvbKVDZC0ZCZCYZAlMPrVxk8ZB1dxMhvLKpLqU04KM9ZBB3SHQOnR6KYwsqrqu14mn7C1jXTPiDYDzaYrxdxpmLZBmrJZBoXWDk6U02LGvysH7BZCbpPhgcLPj4Ue3ZBCPlnqElR1OqYI7K93NvdsMoZAhZBJmtNLWv7EjBuhLF7btl7MZD&message="
const TWITTER_URL := "http://13.251.78.203:3000/twitter/"
onready var profile := {
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
}
var new_character = false
var upgrade_character = false
var user_info := {}
var username
var worldSelected
var difficultySelected
var dateRFC1123
var customLevelSelected
var customLevelBoolean = false

func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId
	}

func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token 
	])

func register(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
	}
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)


func login(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)


func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	

func get_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	print(url)
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)

func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)
	
func generate_fb_link(http: HTTPRequest, mode: String) -> void:
	var url
	get_date_time()
	print(dateRFC1123)
	if (mode == "created"):
		url = FB_URL + "[" + dateRFC1123 + "]%20A%20new%20assignment%20has%20been%20" + mode + "%20by%20" + Firebase.username + ".%20Please%20check%20out%20the%20assignment%20by%20launching%20the%20game%20and%20going%20to%20Custom%20World.%0A&link=https://app.SEQuizGame"
	elif (mode == "updated"):
		url = FB_URL + "[" + dateRFC1123 + "]%20An%20existing%20assignment%20has%20been%20" + mode + "%20by%20" + Firebase.username + ".%20Please%20check%20out%20the%20assignment%20by%20launching%20the%20game%20and%20going%20to%20Custom%20World.%0A&link=https://app.SEQuizGame"
	http.request(url,["Content-Type: application/json"], true, HTTPClient.METHOD_POST,"")

func generate_twitter_link(http: HTTPRequest, mode: String) -> void:
	var body
	get_date_time()
	print(dateRFC1123)
	if (mode == "created"):
		body = "tweet=[" + dateRFC1123 + "]%20A%20new%20assignment%20has%20been%20" + mode + "%20by%20" + Firebase.username + ".%20Please%20check%20out%20the%20assignment%20by%20launching%20the%20game%20and%20going%20to%20Custom%20World.%0Alink=https://app.SEQuizGame"
	elif (mode == "updated"):
		body = "tweet[" + dateRFC1123 + "]%20An%20existing%20assignment%20has%20been%20" + mode + "%20by%20" + Firebase.username + ".%20Please%20check%20out%20the%20assignment%20by%20launching%20the%20game%20and%20going%20to%20Custom%20World.%0Alink=https://app.SEQuizGame"
	http.request(TWITTER_URL,["Content-Type: application/x-www-form-urlencoded"], false, HTTPClient.METHOD_POST, body)	

func get_date_time() -> void:
	var time
	time = OS.get_datetime()
	var nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dayofweek = time["weekday"]   # from 0 to 6 --> Sunday to Saturday
	var day = time["day"]                         #   1-31
	var month= time["month"]               #   1-12
	var year= time["year"]             
	var hour= time["hour"]                     #   0-23
	var minute= time["minute"]             #   0-59
	var second= time["second"]             #   0-59
	dateRFC1123= str(nameweekday[dayofweek]) + ",%20" + str("%02d" % [day]) + "%20" + str(namemonth[month-1]) + "%20" + str(year) + "%20" + str("%02d" % [hour]) + ":" + str("%02d" % [minute]) + ":" + str("%02d" % [second]) + "%20GMT"
