class QualifiedProTOchangePhonetype < ActiveRecord::Migration
  def change
  	change_column :qualified_pros, :phone,  :string
  end
end
