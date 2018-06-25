class SalesGroup < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :name
  validates_format_of :name, :with => /\A\w+\z/, :allow_blank => true
end
