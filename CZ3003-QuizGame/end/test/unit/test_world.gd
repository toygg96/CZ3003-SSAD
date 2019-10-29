extends "res://addons/gut/test.gd"

var World = load('res://interface/world/World.gd')
var world = World.new()

func test_world1_redirect_method_present():
    gut.p("Checking if world 1 redirect method is present")

    assert_has_method(world, '_on_World1_pressed')

func test_world2_redirect_method_present():
    gut.p("Checking if world 2 redirect method is present")

    assert_has_method(world, '_on_World2_pressed')

func test_world3_redirect_method_present():
    gut.p("Checking if world 3 redirect method is present")

    assert_has_method(world, '_on_World3_pressed')

func test_world4_redirect_method_present():
    gut.p("Checking if world 4 redirect method is present")

    assert_has_method(world, '_on_World4_pressed')

func test_world5_redirect_method_present():
    gut.p("Checking if world 5 redirect method is present")

    assert_has_method(world, '_on_World5_pressed')

func test_world6_redirect_method_present():
    gut.p("Checking if world 6 redirect method is present")

    assert_has_method(world, '_on_World6_pressed')