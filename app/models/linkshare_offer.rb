class LinkshareOffer

  attr_accessor :name, :advertiser_id, :buy_url

  def set_attributes_from_response_row(row)
    self.name = row['productname']
    self.advertiser_id = row['mid'].to_i
    self.buy_url = row['linkurl']
    self
  end

end