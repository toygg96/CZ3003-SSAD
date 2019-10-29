extends "res://addons/gut/test.gd"

var Profile = load('res://interface/profile/UserProfile.gd')
var profile = Profile.new()

func test_http_request_method_present():
    gut.p("Checking if http request method is present")

    assert_has_method(profile, '_on_HTTPRequest_request_completed')

func test_set_profile_method_present():
    gut.p("Checking if set profile method is present")

    assert_has_method(profile, 'set_profile')

func test_fetch_exsiting_profile_method_present():
    gut.p("Checking if fetch existing profile method is present")

    assert_has_method(profile, 'fetchExistingProfiel')