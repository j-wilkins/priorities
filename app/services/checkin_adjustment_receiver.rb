class CheckinAdjustmentReceiver
  def self.call(parms, user)
    new(parms, user).call
  end

  attr_reader :parms, :user

  def initialize(parms, user)
    @parms, @user = parms, user
  end

  def call
    multiplier = percentage_multiplier(parms['Body'])
    user.project_checkins.today.each do |chk|
      new_percentage = (chk.percentage * multiplier).to_i
      chk.update_attribute(:percentage, new_percentage)
      chk.update_attribute(:day_weight, multiplier)
    end
  end

  private

  def percentage_multiplier(str)
    if str.include?('.')
      str.to_f
    else
      (str.to_i * 10) / 100.0
    end
  end
end

