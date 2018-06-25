class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :user_id
      t.integer :answer_how_many_offers
      t.integer :answer_edu_level
      t.integer :answer_purchase_factor
      t.integer :answer_job_num

      t.timestamps
    end
  end
end
