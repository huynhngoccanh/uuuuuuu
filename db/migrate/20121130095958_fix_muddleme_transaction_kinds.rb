class FixMuddlemeTransactionKinds < ActiveRecord::Migration
  
  class MuddlemeTransaction < ActiveRecord::Base
  end

  def up
    MuddlemeTransaction.where({:kind=>'cj_commision_without_user_share_add'}).update_all({:kind=>'affiliate_commission_without_user_share_add'})
    MuddlemeTransaction.where({:kind=>'cj_commision_add'}).update_all({:kind=>'affiliate_commission_add'})
    MuddlemeTransaction.where({:kind=>'cj_commision_substract_user_share'}).update_all({:kind=>'affiliate_commission_substract_user_share'})
  end

  def down
  end
end
