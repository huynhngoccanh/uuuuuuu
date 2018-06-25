class RecalculateUserScores < ActiveRecord::Migration
  def up
    User.all.each do |user|
      next if !user.scores.empty?
      user_score = user.scores.build :user=>user, :change_origin=>'migration',
                                   :static_score=>UserScore.resolve_static_score(user),
                                   :dynamic_score=>0,
                                   :change_origin_params=>user.attributes
      user_score.save!

      #dynamic score
      user.auctions.where(:status=>['accepted','rejected']).order('updated_at').each do |auction|
        UserScore.add_score_for_auction(auction)
      end
    end
  end

  def down
  end
end
