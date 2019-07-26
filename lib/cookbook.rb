require 'csv'
require_relative "recipe"

class Cookbook
  def initialize(csv_path)
    @csv_path = csv_path
    @recipes  = []
    load_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    update_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    update_csv
  end

  def all
    @recipes
  end

  private

  def update_csv
    CSV.open(@csv_path, "wb") do |csv_file|
      @recipes.each do |recipe|
        csv_file << [recipe.name, recipe.description]
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_path) do |row|
      name        = row[0]
      description = row[1]
      @recipes << Recipe.new(name, description)
    end
  end
end
