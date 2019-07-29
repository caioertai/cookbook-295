require 'open-uri'
require 'nokogiri'
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

    # 2. Open and read the page with the ingredient search results
    query_url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{ingredient}"
    page_string = open(query_url).read

    # 3. Parse the html text using Nokogiri
    doc = Nokogiri::HTML(page_string)

    # 4. Look at the page structure and use Nokogiri methods to
    #    find the relevant info
    recipe_elements = doc.search('.m_contenu_resultat').first(5)

    # 5. Create an array of recipes
    recipes = recipe_elements.map do |recipe_element|
      name = recipe_element.at('.m_titre_resultat').text.strip
      description = recipe_element.at('.m_texte_resultat').text.strip
      Recipe.new(name, description)
    end

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
