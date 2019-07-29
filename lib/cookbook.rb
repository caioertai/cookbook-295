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
      csv_file << %w[name description prep_time done]
      @recipes.each do |recipe|
        csv_file << [recipe.name, recipe.description, recipe.prep_time, recipe.done?]
      end
    end
  end

  def load_csv
    options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_path, options) do |row|
      @recipes << Recipe.new(row)
    end
  end
end
