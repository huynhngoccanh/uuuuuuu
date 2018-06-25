require 'machinist/active_record'

#Sham.define do
#  name { Faker::Name.name }
#  login { Faker::Internet.user_name }
#  email { Faker::Internet.email }
#  url { Faker::Internet.domain_name }
#  password { rand(99 ** 10).to_s(32) }
#  short_text { Faker::Lorem.words(1+rand(3)) }
#  long_text { (0..6).to_a.map { Faker::Lorem.sentence }.join(" ") }
#  path { Faker::Lorem.words(3).join("_") }
#  city { Faker::Address.city }
#  birthday {Date.today - (12 + rand(50)).years}
#  {File.open("test/assets/photos/#{rand(5)}.jpg")}
#end

User.blueprint do
  email { Faker::Internet.email }
  first_name { Faker::Name::first_name }
  last_name { Faker::Name::last_name }
  zip_code {Faker::Address::zip_code.gsub(/-\d{4}/,'')}
  sex {User::SEX.choice}
  age_range {User::AGE_RANGE.choice}
  password {rand(99 ** 10).to_s(32)}
  password_confirmation { password }
  terms {true}
  confirmed_at {Time.now}
end

Admin.blueprint do
  email { Faker::Internet.email }
  password {rand(99 ** 10).to_s(32)}
  password_confirmation { password }
end

Vendor.blueprint do
  email { Faker::Internet.email }
  company_name { Faker::Company::name }
  first_name { Faker::Name::first_name }
  last_name { Faker::Name::last_name }
  address { Faker::Address::street_address }
  city { Faker::Address::city }
  zip_code {Faker::Address::zip_code.gsub(/-\d{4}/,'')}
  phone {Faker::PhoneNumber::phone_number}
  password {rand(99 ** 10).to_s(32)}
  dont_require_password_confirmation {true}
  password_confirmation { password }
  terms {true}
  confirmed_at {Time.now}
end

FundsTransfer.blueprint do 
  vendor {Vendor.make!}
  amount {20 + rand(90)}
end

FundsTransfer.blueprint(:successful) { 
  amount {30 + rand(90)}
  vendor {Vendor.make!}
  resulting_balance do 
    SystemStats.system_balance + object.amount
  end
  status {'success'}
}

FundsTransferTransaction.blueprint(:purchase) do
  action {"purchase"} 
  transfer {FundsTransfer.make!(:successful)}
  amount {object.transfer.amount_in_cents}
  response { {'transaction_id' => '1'} }
end

ProductCategory.blueprint do
  name {Faker::Lorem.words([1,2].choice)}
end
ServiceCategory.blueprint do
  name {Faker::Lorem.words([1,2].choice)}
end

Auction.blueprint do
  user {User.make!}
  product_category {ProductCategory.make!}
  name { Faker::Lorem.words([1,2,3].choice) }
  product_auction {true}
  status {'active'}
  duration {1+ rand(14)}
  budget {Auction::BUDGET_OPTIONS.choice}
  max_vendors {1+ rand(10)}
  desired_time {Time.now + rand(15).days}
  desired_time {Time.now + rand(15).days}
  contact_time_of_day {$times_of_day.choice}
  contact_way {$contact_ways.choice}
  delivery_method {Auction::DELIVERY_OPTIONS.choice}
end


Bid.blueprint do
  auction {Auction.make!}
  vendor do
    transfer = FundsTransfer.make!(:successful)
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    transfer.vendor
  end
  max_value {object.minimum_value + rand(object.vendor.balance.to_i - object.minimum_value + 1)}
end

Campaign.blueprint do
  name { Faker::Lorem.words([1,2,3].choice) }
  vendor do
    transfer = FundsTransfer.make!(:successful)
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    transfer.vendor
  end
  product_campaign{true}
  offer { Offer.make!(:vendor=>object.vendor)}
  max_bid do 
    min = Auction.new.bid_minimum_value
    min + rand(object.vendor.balance.to_i - min + 1)
  end
  product_categories([1,2,3].choice)
end

Offer.blueprint do
  vendor {Vendor.make!}
  name { Faker::Lorem.words([1,2,3].choice) }
end

FundsWithdrawal.blueprint do
  user do #make user with an auction that earned him some money
    u = User.make!
    amount_min = [FundsWithdrawal::MIN_AMOUNT, Auction.new.bid_minimum_value].max
    transfer = FundsTransfer.make!(:successful, :amount => [amount_min, 30].max + rand(100))
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    bid = Bid.make! :max_value=>transfer.amount.to_i, :vendor=>transfer.vendor, :auction=>Auction.make!(:user=>u, :max_vendors=>1)
    transfer = FundsTransfer.make!(:successful, :amount => bid.max_value.to_i + 1 + rand(10))
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    Bid.make! :max_value=>transfer.amount.to_i, :auction=>bid.auction, :vendor=>transfer.vendor
    bid.auction.resolve_auction true, true
    bid.auction.confirm_auction
    bid.auction.accept_auction
    u.reload
  end
  amount {FundsWithdrawal::MIN_AMOUNT + rand(object.user.auctions.first.user_earnings - FundsWithdrawal::MIN_AMOUNT)}
end

FundsRefund.blueprint do
  vendor do
    transfer = FundsTransfer.make!(:successful)
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    transfer.vendor
  end
  requested_amount {1 + rand(object.vendor.balance.to_i)}
end

ReferredVisit.blueprint do
  user {User.make!}
end

AuctionAddress.blueprint do
  auction {Auction.make!}
  first_name { Faker::Name::first_name }
  last_name { Faker::Name::last_name }
  zip_code {Faker::Address::zip_code.gsub(/-\d{4}/,'')}
  address { Faker::Address::street_address }
  city { Faker::Address::city }
end

AuctionImage.blueprint do
  image {File.open("test/assets/images/#{rand(5)}.jpg")}
end

AvantAdvertiser.blueprint do
  advertiser_id {Digest::SHA1.hexdigest([Time.now, rand].join)}
  name {Faker::Company::name}
end

AvantOffer.blueprint do
  auction {Auction.make!}
  advertiser {AvantAdvertiser.make!}
  name {Faker::Company::name}
  price {1 + rand(19)}
end

AvantCommission.blueprint do
  avant_offer {AvantOffer.make!}
  auction_id_received {object.avant_offer.auction.id}
  commission_amount {1 + rand(19)}
  resulting_balance {SystemStats.system_balance + object.commission_amount}
end

AvantCoupon.blueprint do
  advertiser {AvantAdvertiser.make!}
  header {Faker::Lorem.words(1)[0]}
  code {Faker::Lorem.words(1)[0]}
end

CjAdvertiser.blueprint do
  advertiser_id {Digest::SHA1.hexdigest([Time.now, rand].join)}
  name {Faker::Company::name}
end

CjOffer.blueprint do
  auction {Auction.make!}
  advertiser {CjAdvertiser.make!}
  name {Faker::Company::name}
  price {1 + rand(19)}
end

CjCommission.blueprint do
  cj_offer {CjOffer.make!}
  auction_id_received {object.cj_offer.auction.id}
  commission_amount {1 + rand(19)}
  resulting_balance {SystemStats.system_balance + object.commission_amount}
end

CjCoupon.blueprint do
  advertiser {CjAdvertiser.make!}
  header {Faker::Lorem.words(1)[0]}
  code {Faker::Lorem.words(1)[0]}
end

FundsWithdrawalNotification.blueprint do
  funds_withdrawal do 
    funds_withdrawal = FundsWithdrawal.make! :success=>true
    UserTransaction.create_for funds_withdrawal
    funds_withdrawal
  end
  status {['Failed','Returned','Reversed'].choice}
end

VendorFundsGrant.blueprint do
  vendor {Vendor.make!}
  amount {10 + rand(49)}
end

Survey.blueprint do
  user {User.make!}
end

VendorKeyword.blueprint do
  vendor {Vendor.make!}
  keyword {Faker::Lorem.words(1)[0]}
end

VendorTrackingEvent.blueprint do
  vendor {Bid.make!.vendor}
  auction do 
    auction = object.vendor.auctions.last
    auction.resolve_auction true, true
    auction
  end
  event_type {'converted'}
end

ZipCode.blueprint do
  code {Faker::Address::zip_code.gsub(/-\d{4}/,'')}
  lat {Faker::Address.latitude}
  lng {Faker::Address.longitude}
end