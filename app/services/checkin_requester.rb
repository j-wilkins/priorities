class CheckinRequester

  def self.client
    @client ||= Twilio::REST::Client.new
  end

  def self.run
    User.all.each {|u| call(u)}
  end

  def self.call(user)
    new(user).call
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    abcs = ("a".."z").to_a
    choice_list = user.projects.enabled.map {|pr| "#{abcs.shift}: #{pr.name}"}

    client.messages.create(
      from: message_from_number,
      to: user.phone_number,
      body: checkin_message(choice_list)
    )
  end

  private

  def client
    self.class.client
  end

  def message_from_number
    Rails.application.config.x.message_from_number
  end

  def checkin_message(choice_list)
    "Time to checkin! Rank the following projects:\n\n#{choice_list.join("\n")}"
  end
end
