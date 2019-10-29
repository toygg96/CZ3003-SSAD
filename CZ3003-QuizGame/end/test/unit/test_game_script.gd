extends "res://addons/gut/test.gd"

var Game = load('res://interface/game/game.gd')
var game = Game.new()

func test_get_set_quizzes():
    gut.p('Testing create quiz')
    
    var test_questions = ["testing", "123"]

    assert_accessors(game, "quiz", null, test_questions)

func test_gen_player_life_method_present():
    gut.p('Checking if generate player life method is present')

    assert_has_method(game, '_generate_player_life')

func test_set_question_method_present():
    gut.p('Checking if set question method is present')

    assert_has_method(game, 'set_question')
    
func test_checkAnswer_method_present():
    gut.p('Checking if check answer method is present')

    assert_has_method(game, 'checkAnswer')

func test_consume_ap_method_present():
    gut.p('Checking if consume ap method is present')

    assert_has_method(game, '_consume_AP')
    
func test_damage_method_present():
    gut.p('Checking if damage method is present')

    assert_has_method(game, '_damage')
    
func test_clear_answer_method_present():
    gut.p('Checking if clear answers method is present')

    assert_has_method(game, 'clear_answers')
    
func test_clear_question_answers_method_present():
    gut.p('Checking if clear question answers method is present')

    assert_has_method(game, 'clear_questionsAnswers')
    
func test_set_profile_method_present():
    gut.p('Checking if set_profile method is present')

    assert_has_method(game, 'set_profile')
    
func test_fetch_existing_profile_method_present():
    gut.p('Checking if fetch existing profile method is present')

    assert_has_method(game, 'fetchExistingProfiel')
    
func test_update_profile_method_present():
    gut.p('Checking if update profile method is present')

    assert_has_method(game, '_updateProfile')