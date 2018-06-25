class AddReviewUrlToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :review_url, :string
  end
end
