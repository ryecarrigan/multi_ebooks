require 'twitter_ebooks'

class MultiBot < Ebooks::Bot
  attr_accessor :model

  def configure
    self.access_token = ENV['ACCESS_TOKEN']
    self.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    self.consumer_key = ENV['CONSUMER_KEY']
    self.consumer_secret = ENV['CONSUMER_SECRET']
    self.delay_range = 1..6
  end

  def on_startup
    @blacklist = ENV['BLACKLIST_WORDS'].downcase.split(',')
    @model = build_archive

    scheduler.cron ENV['CRON_SCHEDULE'] do
      tweet build_message
    end
  end

  # Reply to a mention
  def on_mention(tweet)
    reply tweet, meta(tweet).reply_prefix + build_message
  end

  private
  def build_archive
    archives = []
    ENV['ACCOUNT_NAMES'].split(',').each { |account|
      Ebooks::Archive.new(account, nil, make_client).sync
      archives.push "corpus/#{account}.json"
    }

    Ebooks::Model.consume_all archives
  end

  def build_message
    message = model.make_statement

    # Check if the generated message contains a blacklisted word.
    downcase = message.downcase
    blacklisted = @blacklist.any? { |word|
      downcase.include?(word)
    }

    # Valid messages start with a letter and do not end with ellipses.
    is_valid = (message =~ /^[A-Za-z]/) && !message.end_with?('...')

    # If it's formatted incorrectly or contains a blacklisted word, try again.
    (is_valid && !blacklisted) ? message : build_message
  end

  def make_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = self.consumer_key
      config.consumer_secret = self.consumer_secret
      config.access_token = self.access_token
      config.access_token_secret = self.access_token_secret
    end
  end
end

MultiBot.new ENV['EBOOKS_ACCOUNT']
