class QualifiedPro < ActiveRecord::Migration
  def change
  	add_column :qualified_pros ,:phone ,:integer
  	add_column	:qualified_pros	,:service_id ,:integer
  end
end
