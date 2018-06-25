class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :user_id
      t.integer :static_score
      t.float :dynamic_score
      t.string :change_origin
      t.string :change_origin_params
      t.timestamps
    end
  end
end
