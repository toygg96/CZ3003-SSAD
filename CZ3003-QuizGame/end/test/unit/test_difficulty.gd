extends "res://addons/gut/test.gd"

var Assignment = load('res://interface/assignment/CreateAssignment.gd')
	
func test_get_set_questions_exact_match():
	var assignment = Assignment.new()
	var test_question = {
		"question": "test",
		"answer1": "1",
		"answer2": "2",
		"answer3": "3",
		"answer4": "4",
		"correctAns": "2"
	}
	
	assert_accessors(assignment, "test_question", {}, test_question)