desc 'Clear inactive sessions'
task :clear_inactive_sessions => :environment do
  ActiveRecord::SessionStore::Session.delete_all(['updated_at < ?', 2.weeks.ago])
end

desc 'Import soleo categories'
task :import_soleo_categories => :environment do
  SoleoCategory.import_from_spreadsheet
end

desc 'Import preferred advertisers'
task :import_preferred_advertisers => :environment do
  users = User.all
  advertisers = []
  SearchController::PREFERRED_ADVERTISER_NAMES.each { |name| advertisers.push(CjAdvertiser.find_by_name(name) || AvantAdvertiser.find_by_name(name) || LinkshareAdvertiser.find_by_name(name)) }
  advertisers.each do |advertiser|
    unless advertiser.nil?
      FavoriteAdvertiser.transaction do
        users.each do |user|
          favorite_advertiser = FavoriteAdvertiser.new
          favorite_advertiser.cj_advertiser = advertiser.is_a?(CjAdvertiser) ? advertiser : nil
          favorite_advertiser.avant_advertiser = advertiser.is_a?(AvantAdvertiser) ? advertiser : nil
          favorite_advertiser.linkshare_advertiser = advertiser.is_a?(LinkshareAdvertiser) ? advertiser : nil
          favorite_advertiser.user = user
          begin
            favorite_advertiser.save!
          rescue
          end
        end
      end
    end
  end
end