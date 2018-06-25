class McbUpdate < ActiveRecord::Base
  belongs_to :user
  belongs_to :alertable, :polymorphic => true
  validates_uniqueness_of :user_id, :scope => [:alertable_id, :alert_date]
end
