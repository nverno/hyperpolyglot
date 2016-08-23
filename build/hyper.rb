require 'HTTParty'
require 'Nokogiri'
require 'Pry'
require 'csv'

page = HTTParty.get('http://hyperpolyglot.org/')

parse_page = Nokogiri::HTML(page)

File.open("index.html", "w") { |file| file.write(parse_page) }

parse_page.
