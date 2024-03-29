class Recipe
  attr_reader :name, :description, :prep_time

  def initialize(attributes = {})
    @name        = attributes[:name]
    @description = attributes[:description]
    @prep_time   = attributes[:prep_time].to_i
    @done        = attributes[:done] == "true"
  end

  def done?
    @done
  end

  def mark_as_done!
    @done = true
  end
end
