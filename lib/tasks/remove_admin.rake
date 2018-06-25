namespace :muddleme do
  desc "Creating admin"
  
  task :remove_admin => :environment do
    u = Admin.find_by_email("artur@dealdriver.pl")
    puts u.id
    u.destroy
  
  end
  
  task :update_admin => :environment do
    u = Admin.find_by_email("admin@muddleme.com")
    puts u.id
    u.update_attributes(:password=>"mmadmin2020", :password_confirmation=>"mmadmin2020")
    #u.save 
  end  
  
  
task :reload_all_advertisers => :environment do
  CjAdvertiser.reload_all_advertisers
  AvantAdvertiser.reload_all_advertisers
  AvantCoupon.reload_all_coupons
end

desc "Reload Linkshare advertisers/coupons list and save it to db"
task :reload_linkshare_advertisers => :environment do
  LinkshareAdvertiser.reload_all_advertisers
  LinkshareCoupon.reload_all_coupons
end

desc "Fetch new Commission Junction commission data and save it to db"
task :affiliate_fetch_new_commissions => :environment do
  Search::CjCommission.fetch_new_commissions
  Search::AvantCommission.fetch_new_commissions
  Search::LinkshareCommission.fetch_new_commissions
end

desc "Download logos for cj advertisers"
task :cj_fetch_advertisers_logos => :environment do
  CjAdvertiser.fetch_advertisers_logos
end
     
end
