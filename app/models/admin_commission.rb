class AdminCommission < ActiveRecord::Base
  has_one :muddleme_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :user_transaction, :as=>:transactable, :dependent=>:destroy

  belongs_to :user

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}
end
