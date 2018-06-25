module CrawlerJobs
  class LoyaltySignupCrawlerJob < Struct.new(:loyalty_program_id, :user_id, :account_id, :password)
    def perform
      Delayed::Worker.logger.debug("############# Log Entry ###############################")
      loyalty_program = LoyaltyProgram.find(loyalty_program_id)
      loyalty_program_user = LoyaltyProgramsUser.where(user_id: user_id,loyalty_program_id: loyalty_program_id).first
      case loyalty_program.name
      when 'Best Buy'
        SignupCrawler.new.best_buy(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Thrifty'
        SignupCrawler.new.thrifty(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'GNC'
        SignupCrawler.new.gnc(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Petco'
        SignupCrawler.new.petco(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Dicks Sports'
        SignupCrawler.new.dicks_sports(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Gap'
        SignupCrawler.new.gap(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'City Sports'
        SignupCrawler.new.city_sports(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Famous Footwear'
        SignupCrawler.new.famous_footwear(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Foot Locker'
        SignupCrawler.new.foot_locker(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Modells'
        SignupCrawler.new.modells(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Sports Authority'
        SignupCrawler.new.sports_authority(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Kmart'
        SignupCrawler.new.kmart(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Shopn Save'
        SignupCrawler.new.shopn_save(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Virgin America'
        SignupCrawler.new.virgin_america(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Safe Way'
        SignupCrawler.new.safe_way(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Walgreens'
        SignupCrawler.new.walgreens(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'National Car'
        SignupCrawler.new.national_car(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Home Depot'
        SignupCrawler.new.home_depot(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Sears'
        SignupCrawler.new.sears(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Ace Hardware'
        SignupCrawler.new.ace_hardware(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Stop And Shop'
        SignupCrawler.new.stop_and_shop(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Kroger'
        SignupCrawler.new.kroger(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Winn Dixie'
        SignupCrawler.new.winn_dixie(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Food Lion'
        SignupCrawler.new.food_lion(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'United'
        SignupCrawler.new.united(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Delta'
        user_name=SignupCrawler.new.delta(account_id, password)
        loyalty_program_user.account_id = user_name
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'South West'
        SignupCrawler.new.south_west(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Jet Blue'
        SignupCrawler.new.jet_blue(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Macys'
        SignupCrawler.new.macys(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Shurfine Markets'
        SignupCrawler.new.shurfine_markets(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Star Bucks'
        star_bucks_password=password+"$"
        SignupCrawler.new.star_bucks(account_id,  star_bucks_password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password =  star_bucks_password
        loyalty_program_user.save!
      when 'Neiman Marcus'
        SignupCrawler.new.neiman_marcus(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      when 'Target'
        SignupCrawler.new.target(account_id, password)
        loyalty_program_user.account_id = account_id
        loyalty_program_user.password = password
        loyalty_program_user.save!
      end
    end
  end
end
