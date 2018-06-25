require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  test "make" do
    survey = Survey.make
    assert survey.save
  end
end
