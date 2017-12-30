# multi_ebooks

A simple bot built with [twitter_ebooks](https://github.com/mispy/twitter_ebooks) that generates a model from multiple source accounts and tweets on a schedule.


## Usage

Make a copy of `dougie.env.example` as `dougie.env` and populate it with the configuration details:
```dotenv
# The bot's Twitter account name.
EBOOKS_ACCOUNT=

# The access credentials provided by Twitter.
ACCESS_TOKEN=
ACCESS_TOKEN_SECRET=
CONSUMER_KEY=
CONSUMER_SECRET=

# A comma-separated list of source Twitter account names.
ACCOUNT_NAMES=

# A comma-separated list of words to blacklist from generated messages.
BLACKLIST_WORDS=

# A cron schedule to deploy generated tweets.
CRON_SCHEDULE=
```

Then build and start with `docker-compose`:
```bash
docker-compose build
docker-compose up
```

See [twitter_ebooks](https://github.com/mispy/twitter_ebooks) for more details.