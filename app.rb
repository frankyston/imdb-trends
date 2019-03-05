require 'nokogiri'
require 'open-uri'
require 'highline'

class ImdbScrapper

  attr_reader :suggestions, :response
  def initialize() 
    @suggestions = scrapper
  end

  def ask_and_return_search_term
    generate_dialog
    response_of_question
  end

  def scrapper
    uri_base = 'https://www.imdb.com/search/title?count=10&title_type=feature,tv_series&ref_=nv_wl_img_2'
    imdb_html = open(uri_base)
    imdb_nokogiri = Nokogiri::HTML(imdb_html)
    movie_suggestions = imdb_nokogiri.css("div.lister-list div.lister-item h3 a")
    movie_suggestions.map { |suggestion| suggestion.children }
  end

  def generate_dialog
    cli = HighLine.new
    @response = cli.ask options_of_question
  end

  def options_of_question
    questions = "Qual filme deseja? \n"
    @suggestions.each_with_index do |suggestion, index|
      questions += "[#{index+1}] - #{suggestion.to_s} \n"
    end
    questions
  end

  def response_of_question
    "You selected option: #{@suggestions[@response.to_i-1]}"
  end

end

imdb = ImdbScrapper.new
puts imdb.ask_and_return_search_term