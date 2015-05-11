if Rails.env.production?
  require 'raven'
  Raven.configure do |config|
    config.dsn = 'http://a95deea63d7b441496f06f119d6d835b:6384e29c0425493d826780456706ee16@sentry.sapp.io/4'
  end
end
