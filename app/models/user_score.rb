class UserScore < ActiveRecord::Base
  serialize :change_origin_params

  belongs_to :user

  BASE_SCORE = 50
  MAX_SCORE = 100

  CHANGE_ORIGINS = [
    'base', 'user','survey', 'auction', 'migration'
  ]

  SCORE_FOR_ATTRIBUTE_PRESENT = {
    :confirmed_at => 5,
    #:"address city" => 3, !! hardcoded in after user save
    :phone=> 10,
    :sex=>1,
    :age_range=>1,
    :education=>1,
    :occupation=>1,
    :income_range=>1,
    :marital_status=>1,
    :family_size=>1,
    :home_owner=>1,

    :twitter_uid=>3,
    :facebook_uid=>2
  }

  after_create do 
    User.where(id: user.id).update_all({:score=> score_value})
    user.score= score_value
  end

  def score_value
    result = static_score + dynamic_score.floor
    result = [result, UserScore::MAX_SCORE].min
    [result, 0].max
  end

  def self.after_user_create user
    user_score = user.scores.build :user=>user, :change_origin=>'base',
                :static_score=>BASE_SCORE,
                :dynamic_score=>0

    user_score.save!
  end

  def self.after_user_save user
    watched_attrs = SCORE_FOR_ATTRIBUTE_PRESENT.keys + [:address, :city]
    return if (watched_attrs & user.changed.map(&:to_sym)).empty?

    last_user_score = user.scores.first
    new_static_score = self.resolve_static_score(user)

    user_score = user.scores.build :user=>user, :change_origin=>'user',
                                   :static_score=>new_static_score,
                                   :dynamic_score=>last_user_score.dynamic_score,
                                   :change_origin_params=>user.changes
    user_score.save!
  end

  def self.after_survey_change survey
    user = survey.user
    last_user_score = user.scores.first

    new_static_score = self.resolve_static_score(user)

    user_score = user.scores.build :user=>user, :change_origin=>'survey',
                                   :static_score=>new_static_score,
                                   :dynamic_score=>last_user_score.dynamic_score,
                                   :change_origin_params=>survey.changes
    user_score.save!
  end

  def self.resolve_static_score user
    result = BASE_SCORE
    SCORE_FOR_ATTRIBUTE_PRESENT.each do |attr, score|
      result += score if !user.send(attr).blank? || user.send(attr) == false
    end
    result += 3 if !user.address.blank? && !user.city.blank?

    if user.survey
      result += user.survey.points_for_survey
    end
    result
  end

  def self.add_score_for_auction auction
    user = auction.user
    return if !['accepted','rejected'].include?(auction.status)
    return if !user.scores.where(:change_origin=>'auction', :change_origin_params=>auction.id.to_yaml).empty?
    last_user_score = user.scores.first
    new_score = last_user_score.dynamic_score
    if auction.status == "accepted"
      new_score += case
      when user.score <= 50
        2
      when user.score <= 70
        1
      when user.score <= 90
        0.5
      else
        0.25
      end
    else
      new_score -= 1
    end

    user_score = user.scores.build :user=>user, :change_origin=>'auction', 
                                   :static_score=>last_user_score.static_score,
                                   :dynamic_score=>new_score,
                                   :change_origin_params=>auction.id
    user_score.save!                                   
  end



end
