module Admins::AuctionsHelper
  def status_text(auction)
    if auction.status == 'confirmed' && auction.outcome && auction.outcome.purchase_made == false
      "Confirmation negative"
    elsif auction.status == 'confirmed' && auction.outcome && auction.outcome.purchase_made == true
      "Confirmation positive"
    elsif auction.status == 'confirmed' && !auction.outcome
      "Error: auction confirmed, but no outcome found"
    else
      auction.status.humanize
    end

  end

end
