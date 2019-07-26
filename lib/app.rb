require 'pry-byebug'
require_relative "cookbook"
require_relative "controller"
require_relative "router"

cookbook = Cookbook.new("lib/recipes.csv")
controller = Controller.new(cookbook)
router = Router.new(controller)

router.run
