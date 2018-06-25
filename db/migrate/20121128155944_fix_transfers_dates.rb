class FixTransfersDates < ActiveRecord::Migration
  class VendorTransaction < ActiveRecord::Base
    belongs_to :transactable, :polymorphic => true
  end
  class UserTransaction < ActiveRecord::Base
    belongs_to :transactable, :polymorphic => true
  end
  class MuddlemeTransaction < ActiveRecord::Base
    belongs_to :transactable, :polymorphic => true
  end

  def up
    VendorTransaction.includes(:transactable).each do |transaction|
       VendorTransaction.where({:id=>transaction.id}).update_all({
        :created_at=>transaction.transactable.updated_at,
        :updated_at=>transaction.transactable.updated_at
       })
    end

    UserTransaction.includes(:transactable).each do |transaction|
      UserTransaction.where({:id=>transaction.id}).update_all({
        :created_at=>transaction.transactable.updated_at,
        :updated_at=>transaction.transactable.updated_at
         })
    end
    
    MuddlemeTransaction.includes(:transactable).each do |transaction|
      MuddlemeTransaction.where({:id=>transaction.id}).update_all({
        :created_at=>transaction.transactable.updated_at,
        :updated_at=>transaction.transactable.updated_at
         })
    end
  end

  def down
  end
end
