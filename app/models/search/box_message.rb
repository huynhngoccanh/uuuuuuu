class Search::BoxMessage < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :message, :user_id, :type

  attr_accessible :type, :message, :user_id
end
