require 'open-uri'
require 'nokogiri'
require 'csv'

# ! Recuperation de tous les liens des annonces
url = 'https://www.iadfrance.fr/annonces/nancy-54000/location'
domain_name = 'https://www.iadfrance.fr'
html = URI.open(url)
doc = Nokogiri::HTML(html)

# Supposons que vous souhaitiez extraire les titres des annonces
link_annonce = doc.css('.i-card--title a').map { |link| link['href'] }


# Affichage des liens
link_annonce.each do |link|
    puts domain_name + link

    # Enregistrement des liens dans un fichier CSV
    CSV.open('annonces.csv', 'w', write_headers: true, headers: ['url']) do |csv|
        link_annonce.each do |link|
            csv << [domain_name + link]
        end
    end
end

puts "Les liens des annonces ont été enregistrés dans le fichier annonces.csv."
