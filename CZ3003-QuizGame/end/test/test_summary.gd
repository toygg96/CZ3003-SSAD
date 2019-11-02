extends "res://addons/gut/test.gd"

var SummaryReport = load("res://interface/summaryreport/Summary.gd")

var report = SummaryReport.new()

func test_check_valid_total_scores():	
	gut.p("Testing valid total scores")
	
	var test_scores = [{
		"fields" : {
			"overallScore" : { "integerValue" : "20" },
			"W1Score" : { "integerValue" : "20" },
			"W2Score" : { "integerValue" : "20" },
			"W3Score" : { "integerValue" : "20" },
			"W4Score" : { "integerValue" : "20" },
			"W5Score" : { "integerValue" : "20" },
			"W6Score" : { "integerValue" : "20" },
		}
	}, {
		"fields" : {
			"overallScore" : { "integerValue" : "20" },
			"W1Score" : { "integerValue" : "20" },
			"W2Score" : { "integerValue" : "20" },
			"W3Score" : { "integerValue" : "20" },
			"W4Score" : { "integerValue" : "20" },
			"W5Score" : { "integerValue" : "20" },
			"W6Score" : { "integerValue" : "20" },
		}
	}]
	
	var test_result = report.compute_total_scores(test_scores)
	
	for result in test_result:
		assert_eq(result, 40)
		
func test_check_invalid_total_scores():
	gut.p("Testing invalid total scores")
	
	var test_scores = [{
		"fields" : {
			"overallScore" : { "integerValue" : "20" },
			"W1Score" : { "integerValue" : "20" },
			"W2Score" : { "integerValue" : "20" },
			"W3Score" : { "integerValue" : "20" },
			"W4Score" : { "integerValue" : "20" },
			"W5Score" : { "integerValue" : "20" },
			"W6Score" : { "integerValue" : "20" },
		}
	}, {
		"fields" : {
			"overallScore" : { "integerValue" : "abcd" },
			"W1Score" : { "integerValue" : "20" },
			"W2Score" : { "integerValue" : "20" },
			"W3Score" : { "integerValue" : "20" },
			"W4Score" : { "integerValue" : "20" },
			"W5Score" : { "integerValue" : "20" },
			"W6Score" : { "integerValue" : "20" },
		}
	}]
	
	var test_result = report.compute_total_scores(test_scores)
	
	assert_ne(test_result[0], 40)
	
func test_valid_gen_ave_score():
	gut.p("Test generate valid average score")
	
	var testing_score1 = 100
	var testing_score2 = 169
	
	assert_between(report.gen_average_score(testing_score1, 30), 3, 4)
	assert_between(report.gen_average_score(testing_score2, 37), 4, 5)
		
func test_invalid_gen_ave_score():
	gut.p("Test generate invalid average score")
	
	var testing_score1 = 100
	var testing_score2 = "abcd"
	
	assert_between(report.gen_average_score(testing_score1, 30), 3, 4)
	assert_null(report.gen_average_score(testing_score2, 30))