class ScrapeService
  BASE_QUERY_URL = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt="

  def initialize(query)
    @query = query
  end

  def call
    # 1. Open and read the page with the ingredient search results
    query_url = BASE_QUERY_URL + @query
    page_string = open(query_url).read

    # 2. Parse the html text using Nokogiri
    doc = Nokogiri::HTML(page_string)

    # 3. Look at the page structure and use Nokogiri methods to
    #    find the relevant info
    recipe_elements = doc.search('.m_contenu_resultat').first(5)

    # 4. Create an array of recipes
    recipes = recipe_elements.map do |recipe_element|
      name = recipe_element.at('.m_titre_resultat').text.strip
      description = recipe_element.at('.m_texte_resultat').text.strip

      # This gsub is taking everything that is NOT a digit in the text, and
      # deleting it.
      prep_time = recipe_element.at(".m_detail_time div").text.gsub(/\D/, '')
      Recipe.new(name: name, description: description, prep_time: prep_time)
    end
  end
end
