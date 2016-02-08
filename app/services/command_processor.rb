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
    bd[1..-1].split(' ').first.intern
  end

  def stats
    send_message(StatsMessage.build(user))
  end

  def project
    pname = parms['Body'].split(' ', 2).last
    user.projects.create(name: pname, enabled: true)

    send_message("Created new project named '#{pname}'")
  end

  def disable
    pname = parms['Body'].split(' ', 2).last
    project = user.projects.find_by(name: pname)

    if project
      project.update_attribute(enabled: false)
      msg = "Disabled project named '#{pname}'"
    else
      msg = "Could not find a project named '#{pname}', please say: '!disable <project name>'"
    end

    send_message(msg)
  end

  private

  def send_message(msg)
    TwimlText.new do |t|
      t.Message msg
    end
  end
end
