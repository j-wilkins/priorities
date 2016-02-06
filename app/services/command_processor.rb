class CommandProcessor
  TwimlText = Twilio::TwiML::Response
  def self.call(parms, user)
    new(parms, user).call
  end

  attr_reader :parms, :user

  def initialize(parms, user)
    @parms, @user = parms, user
  end

  def call
    send(command_for_body)
  end

  def command_for_body
    bd = parms['Body'].clone
    bd[1..-1].intern
  end

  def stats
    TwimlText.new do |t|
      t.message StatsMessage.build(user)
    end
  end
end
