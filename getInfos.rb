require 'open-uri'
require 'nokogiri'
require 'csv'
require 'write_xlsx'

# Création du fichier Excel
workbook = WriteXLSX.new('annonces.xlsx')
worksheet = workbook.add_worksheet

# Style pour les en-têtes
header_format = workbook.add_format
header_format.set_bold
header_format.set_color('white')
header_format.set_bg_color('blue')

# Écriture des en-têtes
worksheet.write(0, 0, 'Titre', header_format)
worksheet.write(0, 1, 'Prix', header_format)
worksheet.write(0, 2, 'Localisation', header_format)
worksheet.write(0, 3, 'Numéro de téléphone', header_format)
worksheet.write(0, 4, 'Nom du vendeur', header_format)
worksheet.write(0, 5, 'Note du vendeur', header_format)

# Récupération des liens à partir du fichier CSV
link_annonce = []
CSV.foreach('annonces.csv', headers: true) do |row|
  link_annonce << row['url']
end

# Écriture des informations dans le fichier Excel
row_index = 1
link_annonce.each do |link|
  sleep(1)
  url = link
  domain_name = 'https://www.iadfrance.fr'
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  titles = doc.css('.read-col-left .ellipsis-2').map(&:text)
  prices = doc.css('.read-col-left .adPrice').map(&:text)
  localisations = doc.css('.read-col-left .transactionInfo').map(&:text)
  phone_numbers = doc.css('.read-col-right .i-card-style button').map{ |node| node.attribute('data-phone') }
  vendor_name = doc.css('.read-col-right .agent_name').map(&:text)
  vendor_note = doc.css('.read-col-right .immodvisor-rating .span').map(&:text)

  titles.each_with_index do |title, index|
    worksheet.write(row_index, 0, title)
    worksheet.write(row_index, 1, prices[index])
    worksheet.write(row_index, 2, localisations[index])
    worksheet.write(row_index, 3, phone_numbers[index])
    worksheet.write(row_index, 4, vendor_name[index])
    worksheet.write(row_index, 5, vendor_note[index])

    row_index += 1
  end
end

# Fermeture du fichier Excel
workbook.close

puts "Les informations ont été enregistrées dans le fichier annonces.xlsx."
