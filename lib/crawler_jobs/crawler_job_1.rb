class CrawlerJob < Struct.new(:email)
  def perform
    comand = 'rspec spec/crawler/crawler_api.rb'
    exec comand
  end
end
