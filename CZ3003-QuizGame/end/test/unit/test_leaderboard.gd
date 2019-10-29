extends "res://addons/gut/test.gd"

var Game = load('res://interface/leaderboard/leaderboard.gd')

func test_get_set_leaderboard():
    gut.p('Testing create user')
    var game = Game.new()
    var test_question = ["tom", "harry", "tim"]
    assert_accessors(game, "user", [], test_question)
    