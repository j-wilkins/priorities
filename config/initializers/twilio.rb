
Twilio.configure do |config|
  config.account_sid = ENV["TWILIO_ACCOUNT_SID"]
  config.auth_token  = ENV["TWILIO_AUTH_TOKEN"]
end

Rails.application.config.x.message_from_number = ENV["TWILIO_FROM_NUMBER"]

