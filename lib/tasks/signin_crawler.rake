require "#{Rails.root}/lib/crawler_jobs/capybara_with_phantom_js"


def winn_dixie
  
 
  browser = Capybara.current_session
  url = "https://coupons.winndixie.com/"
  browser.visit url
 

  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
  
  
  sleep(15)
  pods=browser.all 'div.pages div.page div.pod div.media'
     
                
                  pods.each do |pod|
                  
      
                   
      
            
              
                   header=pod.all('p')[0].text+" "+pod.all('p')[1].text

                   if !(LoyaltyProgramCoupon.where(loyalty_program_id: 14,header: header).exists?)

                    loyalty_program_coupon=LoyaltyProgramCoupon.new
                    loyalty_program_coupon.loyalty_program_id=14
                    loyalty_program_coupon.loyalty_program_name="Winn Dixie"
                    loyalty_program_coupon.header= header
                   # loyalty_program_coupon.ad_id=
                    loyalty_program_coupon.ad_url="https://coupons.winndixie.com/"
                    loyalty_program_coupon.description=pod.all('p')[2].text
                  #  loyalty_program_coupon.dont_require_code=true
                    loyalty_program_coupon.start_date=Date.today
                    loyalty_program_coupon.expires_at=pod.all('p')[3].text.remove "Exp: "
                    loyalty_program_coupon.save

                  end

                  end
 
    
end

def macys
  browser = Capybara.current_session
  url = "http://www.macys.com/"
  browser.visit url
 
  
  byebug

  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
   sleep(5)
  browser.execute_script "window.scrollBy(0,100000)"
  
  
  sleep(15)
  pods=browser.all 'div.pages div.page div.pod div.media'
     
                
                  pods.each do |pod|
                  
      
                   
      
            
              
                   header=pod.all('p')[0].text+" "+pod.all('p')[1].text

                   if !(LoyaltyProgramCoupon.where(loyalty_program_id: 10,header: header).exists?)

                    loyalty_program_coupon=LoyaltyProgramCoupon.new
                    loyalty_program_coupon.loyalty_program_id=10
                    loyalty_program_coupon.loyalty_program_name="Winn Dixie"
                    loyalty_program_coupon.header= header
                   # loyalty_program_coupon.ad_id=
                    loyalty_program_coupon.ad_url="https://coupons.winndixie.com/"
                    loyalty_program_coupon.description=pod.all('p')[2].text
                  #  loyalty_program_coupon.dont_require_code=true
                    loyalty_program_coupon.start_date=Date.today
                    loyalty_program_coupon.expires_at=pod.all('p')[3].text.remove "Exp: "
                    loyalty_program_coupon.save

                  end

                  end
 
    
end

def neiman_marcus
  browser = Capybara.current_session
  url = "http://www.neimanmarcus.com/en-pk/Sale/"
  browser.visit url
 
  
  byebug

  find_link('productTemplateId')
  
  
  sleep(15)
  a=browser.all 'li.category-item'

     
                
    
 
    
end

task :signin => :environment do
  include ::CapybaraWithPhantomJs
  new_session
  
  winn_dixie
  #neiman_marcus
  
end

