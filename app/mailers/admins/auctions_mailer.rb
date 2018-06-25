class Admins::AuctionsMailer < ActionMailer::Base
  helper 'application'

  default :from => "noreply@#{HOSTNAME_CONFIG['hostname']}"
  default :to => "admin@ubitru.com"

  def user_provide_auction_outcome auction, outcome
    @auction = auction
    @outcome = outcome

    mail :subject => "[provide auction outcome comment] Auction ##{@auction.number} (#{@auction.name})"
  end

  def vendor_confirm_auction_outcome auction, vendor_outcome
    @auction = auction
    @vendor_outcome = vendor_outcome

    mail :subject => "[confirm auction outcome comment] Auction ##{@auction.number} (#{@auction.name})"
  end
end
