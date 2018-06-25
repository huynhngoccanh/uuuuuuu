class AddAnswerDeliveryPreferenceToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :answer_delivery_preference, :integer, {:after=>:answer_job_num}
  end
end
