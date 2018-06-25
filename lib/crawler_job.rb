module CrawlerJobs
  class CrawlerJob < Struct.new(:email, :password)
    def perform
      Delayed::Worker.logger.debug("############# Log Entry ###############################")
      comand = "email=#{email},#{password} rake ssi"
      exec comand
    end
  end
end
