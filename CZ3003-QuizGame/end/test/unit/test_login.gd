extends "res://addons/gut/test.gd"

var Login = load('res://interface/login/Login.gd')

func test_http_request_method_present():
    gut.p("Checking if http request method is present")
    var login = Login.new()

    assert_has_method(login, '_on_HTTPRequest_request_completed')
