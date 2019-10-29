extends "res://addons/gut/test.gd"

var Firebase = load('res://interface/static/Firebase.gd')
var firebase = Firebase.new()

func test_get_user_info_method_present():
    gut.p("Checking if get user info method is present")

    assert_has_method(firebase, '_get_user_info')

func test_register_method_present():
    gut.p("Checking if register method is present")

    assert_has_method(firebase, 'register')

func test_login_method_present():
    gut.p("Checking if login method is present")

    assert_has_method(firebase, 'login')

func test_save_document_method_present():
    gut.p("Checking if save method is present")

    assert_has_method(firebase, 'save_document')

func test_get_document_method_present():
    gut.p("Checking if login method is present")

    assert_has_method(firebase, 'get_document')

func test_update_document_method_present():
    gut.p("Checking if login method is present")

    assert_has_method(firebase, 'update_document')

func test_delete_document_method_present():
    gut.p("Checking if login method is present")

    assert_has_method(firebase, 'delete_document')

func test_gen_fb_link_method_present():
    gut.p("Checking if generate fb link method is present")

    assert_has_method(firebase, 'generate_fb_link')