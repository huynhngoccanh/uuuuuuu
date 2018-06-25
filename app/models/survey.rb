class Survey < ActiveRecord::Base
  #!/bin/env ruby
  # encoding: utf-8
  # puts "hello world @@@@@@@@@@@@@"
  POINTS_FOR_SURVEY_QUESTION = 1

  QUESTIONS = {
      :answer_how_many_offers => {
          :label => "Merchants reviewed before purchase:",
          :options => {
              1 => "1 Merchant",
              3 => "5+ Merchants"
          }
      },
      :answer_edu_level => {
          :label => "",
          :options => {
              1 => "High School/GED (12 years)",
              2 => "Bachelors (16 years)",
              3 => "Masters (18 years)",
              4 => "Other (20+)"
          }
      },
      :answer_purchase_factor => {
          :label => "Decision factor:",
          :options => {
              1 => "Price",
              2 => "Brand/Quality",
              3 => "What is Hot at the Moment",
              4 => "Customer Reviews"
          }
      },
      :answer_job_num => {
          :label => "Jobs in last ten yrs:",
          :options => {
              1 => "Job, what job?",
              2 => "Just 1",
              3 => "3 or less",
              4 => "4 or more",
              5 => "I work two jobs now"
          }
      },
      :answer_delivery_preference => {
          :label => "Delivery preference:",
          :options => {
              1 => "Self-pickup",
              2 => "Shipping"
          }
      }
  }
  
  belongs_to :user

  after_save do 
    UserScore.after_survey_change self
  end
  
  def points_for_survey
    result = 0
    attribute_names.each do |attr|
      next if attr.index('answer') != 0
      result += POINTS_FOR_SURVEY_QUESTION unless self.send(attr).nil?
    end
    result
  end
  
  def has_unanswered?
    attribute_names.each do |attr|
      next if attr.index('answer') != 0
      return true if self.send(attr).nil?
    end
    false
  end
  
  def answered_count
    result = 0
    attribute_names.each do |attr|
      next if attr.index('answer') != 0
      result += 1 unless self.send(attr).nil?
    end
    result
  end
  
  def unanswered_count
    result = 0
    attribute_names.each do |attr|
      next if attr.index('answer') != 0
      result += 1 if self.send(attr).nil?
    end
    result
  end
  
  def self.questions_count
    result = 0
    attribute_names.each do |attr|
      result += 1 if attr.index('answer') == 0
    end
    result
  end
end
