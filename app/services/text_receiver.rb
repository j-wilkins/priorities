class TextReceiver
  TwimlText = Twilio::TwiML::Response

  def self.call(parms)
    new(parms).call
  end

  attr_reader :parms

  def initialize(pars)
    @parms = pars
  end

  def call
    user = User.find_by(phone_number: parms['From'])
    return false unless user

    send(BodyResolver.resolve(parms['Body'], user), parms, user)
  end

  private

  def checkin(parms, user)
    CheckinReceiver.call(parms, user)
    successful_checkin_response
  end

  def checkin_adjustment(parms, user)
    CheckinAdjustmentReceiver.call(parms, user)
    checkin_adjustment_response
  end

  def invalid(parms, user)
    TwimlText.new do |t|
      t.message "Sorry, I couldn't parse your checkin. Please try again. (I'm sending your original response next so you can copy/pasta)"
      t.message parms["Body"]
    end
  end

  def successful_checkin_response
    TwimlText.new do |t|
      t.message "Checkin Received. If today was not a full day, respond with a modifier (0-9)"
    end
  end

  def checkin_adjustment_response
    TwimlText.new do |t|
      t.message "Adjustment received and applied. Enjoy your evening!"
    end
  end

  module BodyResolver
    def self.resolve(body, user)
      if body =~ /[a-zA-Z](:[0-9]|)/
        :checkin
      elsif body =~ /[a-zA-Z]{1,}/
        :checkin
      elsif body =~ /[0-9]{1,2}(\.[0-9]|)/
        :checkin_adjustment
      else
        :invalid
      end
    end
  end

end