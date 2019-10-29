extends "res://addons/gut/test.gd"

var Leaderboard = load('res://interface/leaderboard/leaderboard.gd')
var lb = Leaderboard.new()

func test_get_set_leaderboard():
    gut.p('Testing create user')

    var test_users = ["tom", "harry", "tim"]
    assert_accessors(lb, "user", [], test_users)

func test_sort_method_present():
    gut.p('Checking if sorting method is present')

    assert_has_method(lb, 'bubbleSortRankings')