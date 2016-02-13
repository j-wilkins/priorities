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
    return register_user unless user

    send(BodyResolver.resolve(parms['Body'], user), parms, user)
  end

  private

  def command(parms, user)
    CommandProcessor.call(parms, user)
  end

  def checkin(parms, user)
    thing = CheckinReceiver.call(parms, user)
    successful_checkin_response(thing)
  end

  def checkin_adjustment(parms, user)
    CheckinAdjustmentReceiver.call(parms, user)
    checkin_adjustment_response
  end

  def invalid(parms, user)
    TwimlText.new do |t|
      t.Message "Sorry, I couldn't parse your checkin. Please try again. (I'm sending your original response next so you can copy/pasta)"
      t.Message parms["Body"]
    end
  end

  def successful_checkin_response(receipt)
    TwimlText.new do |t|
      t.Message receipt.message
    end
  end

  def checkin_adjustment_response
    TwimlText.new do |t|
      t.Message "Adjustment received and applied. Enjoy your evening!"
    end
  end

  def register_user
    if parms['Body'].split(' ').first == 'register'
      name = parms['Body'].split(' ', 2).last
      u = User.create(name: name, phone_number: parms['From'])
      TwimlText.new do |t|
        t.Message "Welcome #{u.name}!\n\nYou need some projects. To create one, respond '!project <project name>'\n\nAfter that, we'll be texting you at 7pm PST to ask what your priorities were for the day."
      end
    else
      TwimlText.new do |t|
        t.Message "Welcome new user! We're currently not registering new people yet. Please check back later."
      end
    end
  end

end
