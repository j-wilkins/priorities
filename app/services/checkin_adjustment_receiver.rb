class CheckinAdjustmentReceiver
  def self.call(parms, user)
    new(AdjustmentString.new(parms['Body']), user).call
  end

  attr_reader :adjustment, :user, :checkin_date

  def initialize(parms, user, day = nil)
    @adjustment, @user, @checkin_date = parms, user, day || CheckinDay.today(user)
  end

  def call
    adjust_day
    adjust_all_projects_for_day
  end

  def adjust_day
    checkin_date.update_attribute(:day_weight, adjustment.multiplier)
  end

  def adjust_all_projects_for_day
    user.project_checkins.on_day(checkin_date).each do |chk|
      new_percentage = (chk.percentage * adjustment.multiplier).to_i
      chk.update_attribute(:percentage, new_percentage)
    end
  end
end

