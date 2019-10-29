extends "res://addons/gut/test.gd"

var Register = load('res://interface/register/Register.gd')
var register = Register.new()

func test_http_request_method_present():
    gut.p("Checking if http request method is present")

    assert_has_method(register, '_on_HTTPRequest_request_completed')