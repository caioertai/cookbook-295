require 'open-uri'
require 'nokogiri'
require_relative "view"
require_relative "scrape_service"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view     = View.new
  end

  def list
    display_recipes
  end

  def create
    # Prompt user for recipe name        <-- View
    recipe_name        = @view.ask_for("name")

    # Prompt user for recipe description <-- View
    recipe_description = @view.ask_for("description")

    # Prompt user for recipe prep_time <-- View
    recipe_prep_time   = @view.ask_for("preparation time")

    # Instantiate a recipe               <-- Recipe
    recipe = Recipe.new(
      name: recipe_name,
      description: recipe_description,
      prep_time: recipe_prep_time
    )

    # Store it                           <-- Cookbook
    @cookbook.add_recipe(recipe)
  end

  def destroy
    display_recipes

    # Ask a recipe index    <- View
    index = @view.ask_for_index

    # Destroy the recipe    <- Cookbook
    @cookbook.remove_recipe(index)
  end

  def import
    # 1. Ask the user for an ingredient
    ingredient = @view.ask_for("ingredient")

    # 2. Ask the ScrapeService for an array of recipes
    #    We move the "logic" behind the scraping to its own class. The
    #    controller is supposed to give orders around. It's the brains of the
    #    operation, not the brawn.
    recipes = ScrapeService.new(ingredient).call

    # 6. Display recipes to the user
    @view.display(recipes)

    # 7. Ask for the index of recipe to be added
    index = @view.ask_for_index

    # 8. Pick the selected recipe from the array
    recipe = recipes[index]

    # 9. Store the recipe
    @cookbook.add_recipe(recipe)
  end

  def mark_as_done
    # Display recipes
    display_recipes

    # Ask for the index to mark
    index = @view.ask_for_index

    # Ask the cookbook to mark a recipe (read this method on the Cookbook for
    # more info)
    @cookbook.mark_recipe_as_done(index)

    # Display recipes again (now that the selected is marked)
    display_recipes
  end

  private

  def display_recipes
    # Get the recipes       <- Cookbook
    recipes = @cookbook.all

    # List the recipes      <- View
    @view.display(recipes)
  end
end
