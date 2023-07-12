require 'open-uri'
require 'nokogiri'
require 'csv'

pages = (1..30).to_a

# Recuperation de tous les liens des annonces
domain_name = 'https://www.iadfrance.fr'
array_links = []

pages.each do |page|
sleep(1.5)
  url = "https://www.iadfrance.fr/annonces/location?page=#{page}"
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  # Supposons que vous souhaitiez extraire les titres des annonces
  link_annonce = doc.css('.i-card--title a').map { |link| link['href'] }

  # Affichage des liens
  link_annonce.each do |link|
    puts domain_name + link
    array_links << domain_name + link
  end
end

# Enregistrement des liens dans un fichier CSV
CSV.open('annonces.csv', 'w', write_headers: true, headers: ['url']) do |csv|
  array_links.each do |link|
    csv << [link]
  end
end

puts "Les liens des annonces ont été enregistrés dans le fichier annonces.csv."
