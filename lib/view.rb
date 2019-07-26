class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.name}\n   #{recipe.description}"
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
