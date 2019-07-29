class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      x = recipe.done? ? "X" : " "
      puts "#{index + 1}. [#{x}] #{recipe.name} (#{recipe.prep_time}min)\n   #{recipe.description}"
    end
  end

  def ask_for(something)
    puts "What's the #{something}?"
    print "> "
    gets.chomp
  end

  def ask_for_index
    puts "Which one? (by number)"
    print "> "
    gets.chomp.to_i - 1
  end
end
