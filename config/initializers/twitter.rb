twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = $tw_consumer_key
  config.consumer_secret = $tw_consumer_secret
end

