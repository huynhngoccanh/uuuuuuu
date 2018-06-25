desc 'Reload joined advertisers list from all networks and save it to db'
task :reload_all_advertisers => :environment do
  CjAdvertiser.reload_all_advertisers
  AvantAdvertiser.reload_all_advertisers
  LinkshareAdvertiser.reload_all_advertisers
  PjAdvertiser.reload_all_advertisers
  IrAdvertiser.reload_all_advertisers
end

desc 'Reload all coupons from all networks and save it to db'
task :reload_all_coupons => :environment do
  CjCoupon.reload_all_coupons rescue nil
  AvantCoupon.reload_all_coupons rescue nil
  LinkshareCoupon.reload_all_coupons rescue nil
  PjCoupon.reload_all_coupons rescue nil
  IrCoupon.reload_all_coupons rescue nil
end

desc 'Fetch new Commission Junction/Avant commission data and save it to db'
task :affiliate_fetch_new_commissions => :environment do
  Search::CjCommission.fetch_new_commissions
  Search::AvantCommission.fetch_new_commissions
  Search::LinkshareCommission.fetch_new_commissions
  Search::PjCommission.fetch_new_commissions
  Search::IrCommission.fetch_new_commissions
end

desc 'Download logos for cj advertisers'
task :cj_fetch_advertisers_logos => :environment do
  CjAdvertiser.fetch_advertisers_logos
end

desc 'Schedular test on production'
task :schedular_test_on_production => :environment do
  ContactMailer.test_mail_from_production_schedular.deliver
end