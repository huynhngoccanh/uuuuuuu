class ChangeUserScoresChangeOriginParamsToText < ActiveRecord::Migration
  def up
    change_column :user_scores, :change_origin_params, :text
  end

  def down
    change_column :user_scores, :change_origin_params, :string
  end
end
