require 'test_helper'

class UserScoreTest < ActiveSupport::TestCase
  test "static score on create and update" do
    user = User.make!
    # 20 base + 5 for email confirmed + 1 for sex + 1 for age_range
    assert_equal 27, user.score
    #base and attributes
    assert_equal 2, user.scores.count

    user.update_attributes :education=> User::EDUCATION.choice
    assert_equal 28, user.score
    assert_equal 3, user.scores.count

    #address is special
    user.update_attributes :address=>'an adress'
    assert_equal 28, user.score
    assert_equal 4, user.scores.count

    user.update_attributes :city=>'a city'
    assert_equal 31, user.score
    assert_equal 5, user.scores.count
  end

  test "dynamic score" do
    user = User.make!
    expected_score = user.score

    while user.score <=50
      auction = Auction.make! :user=>user
      Bid.make! :auction=>auction
      auction.resolve_auction true,true
      auction.confirm_auction
      auction.accept_auction
      expected_score += 2
      assert_equal expected_score, user.reload.score
    end

    while user.score <=70
      auction = Auction.make! :user=>user
      Bid.make! :auction=>auction
      auction.resolve_auction true,true
      auction.confirm_auction
      auction.accept_auction
      expected_score += 1
      assert_equal expected_score, user.reload.score
    end

    while user.score <=90
      auction = Auction.make! :user=>user
      Bid.make! :auction=>auction
      auction.resolve_auction true,true
      auction.confirm_auction
      auction.accept_auction
      expected_score += 0.5
      assert_equal expected_score.floor, user.reload.score
    end

    while user.score < UserScore::MAX_SCORE
      auction = Auction.make! :user=>user
      Bid.make! :auction=>auction
      auction.resolve_auction true,true
      auction.confirm_auction
      auction.accept_auction
      expected_score += 0.25
      assert_equal expected_score.floor, user.reload.score
    end

    assert_equal UserScore::MAX_SCORE, user.reload.score
  end
end
