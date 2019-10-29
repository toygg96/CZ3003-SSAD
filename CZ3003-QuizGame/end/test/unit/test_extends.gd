extends "res://addons/gut/test.gd"

var Assignment = load('res://interface/assignment/CreateAssignment.gd')
var Difficulty = load('res://interface/difficulty/difficulty.gd')
var Game = load('res://interface/game/game.gd')
var Leaderboard = load('res://interface/leaderboard/leaderboard.gd')
var Login = load('res://interface/login/Login.gd')
var Profile = load('res://interface/profile/UserProfile.gd')
var Register = load('res://interface/register/Register.gd')
var Firebase = load('res://interface/static/Firebase.gd')
var World = load('res://interface/world/world.gd')


func test_assert_is():
	gut.p('Testing asignment extends')
	assert_is(Assignment.new(), Node)
	
	gut.p('Testing difficulty extends')
	assert_is(Difficulty.new(), Control)
	
	gut.p('Testing game extends')
	assert_is(Game.new(), TextureRect)
	
	gut.p('Testing leaderboard extends')
	assert_is(Leaderboard.new(), Node)
	
	gut.p('Testing login extends')
	assert_is(Login.new(), Control)
	
	gut.p('Testing profile extends')
	assert_is(Profile.new(), Control)
	
	gut.p('Testing register extends')
	assert_is(Register.new(), Control)
	
	gut.p('Testing firebase extends')
	assert_is(Firebase.new(), Node)
	
	gut.p('Testing world extends')
	assert_is(World.new(), Control)