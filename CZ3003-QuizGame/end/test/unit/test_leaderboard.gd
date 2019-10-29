extends "res://addons/gut/test.gd"

var Leaderboard = load('res://interface/leaderboard/leaderboard.gd')

func test_get_set_leaderboard():
    gut.p('Testing create user')
    var lb = Leaderboard.new()
    var test_users = ["tom", "harry", "tim"]
    assert_accessors(lb, "user", [], test_users)
    