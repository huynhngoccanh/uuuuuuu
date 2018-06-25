task :best_buy_categories_to_csv => :environment do
  CSV.open("tmp/best_buy_categories.csv", "w") do |csv|

    csv << ['id','name','parent categories', 'child categoeies']
    page = 0
    begin
      page += 1
      response = BestBuy.categories page

      break if response.nil? || response['categories'].blank? || response['categories']['category'].blank?
      categories = response['categories']['category']
      categories = [categories] if !categories.is_a? Array
      categories.each do |c|
        subc = []
        if c['subCategories'] && c['subCategories']['category']
          subc = c['subCategories']['category']
          subc = [subc] if !subc.is_a? Array
        end
        parc = []
        if c['path'] && c['path']['category']
          parc = c['path']['category']
          parc = [parc] if !parc.is_a? Array
        end
        csv << [c['id'], c['name'], parc.map{|s| s['name']}.join(' -> '), subc.map{|s| s['name']}.join(' -> ')]
      end

      bar ||= RakeProgressbar.new(response['categories']['totalPages'].to_i)
      bar.inc if bar 
    end until response['categories']['curentPage'].to_i == response['categories']['totalPages'].to_i
  end 
end

task :recognize_generate_xml_form_best_buy => :environment do
  RecognizeImage.generate_xml_for_recognize
end