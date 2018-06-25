desc "Check for active auctions that already ended resolve outcome and send out emails, also auto reject and auto accept outcome if applicable"
task :recognize_fetch_all_etilize_images => :environment do
  RecognizeImage.delete_all
  RecognizeImage.fetch_all_etilize true
end

task :recognize_fetch_all_best_buy_images => :environment do
  RecognizeImage.delete_all
  RecognizeImage.fetch_all_best_buy true
end

task :recognize_generate_xml => :environment do
  RecognizeImage.generate_xml_for_recognize
end