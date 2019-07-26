require_relative "view"

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
    # Instantiate a recipe               <-- Recipe
    recipe = Recipe.new(recipe_name, recipe_description)
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

  private

  def display_recipes
    # Get the recipes       <- Cookbook
    recipes = @cookbook.all
    # List the recipes      <- View
    @view.display(recipes)
  end
end
