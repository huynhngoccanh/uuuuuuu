class AddFromUniversityLandingPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :from_university_landing_page, :boolean
  end
end
