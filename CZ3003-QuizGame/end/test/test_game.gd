extends "res://addons/gut/test.gd"

var Game = load("res://interface/game/game.gd")
var game = Game.new()

func test_valid_total_world_score():
	gut.p("Verify if player's total score is correct")
	
	var base_score = 3000
	var alt_attempt_1 = 6000
	var alt_attempt_2 = 9000
	
	assert_eq(game.update_world_score(base_score, alt_attempt_1, alt_attempt_2), 18000)
	
func test_invalid_base_score():
	gut.p("Verify if player's total score is invalid because of base_score")
	
	var base_score = "abcd"
	var alt_attempt_1 = 6000
	var alt_attempt_2 = 9000
	
	assert_null(game.update_world_score(base_score, alt_attempt_1, alt_attempt_2))
	
func test_invalid_alt_attempt_1_score():
	gut.p("Verify if player's total score is invalid because of alt_attempt_1")
	
	var base_score = 3000
	var alt_attempt_1 = "abcd"
	var alt_attempt_2 = 9000
	
	assert_null(game.update_world_score(base_score, alt_attempt_1, alt_attempt_2))
	
func test_invalid_alt_attempt_2_score():
	gut.p("Verify if player's total score is invalid because of alt_attempt_2")
	
	var base_score = 3000
	var alt_attempt_1 = 6000
	var alt_attempt_2 = "abcd"
	
	assert_null(game.update_world_score(base_score, alt_attempt_1, alt_attempt_2))
	