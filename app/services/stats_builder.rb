class StatsBuilder
  def self.call(user)
    new(user).call
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    out = {}
    return out if user.projects.enabled.count == 0

    day_count = CheckinDay.day_count(user)

    percentage_sums = user.project_checkins.group(:project_id).sum(:percentage)

    user.projects.each do |pr|
      percentage = ((percentage_sums[pr.id] || 0) / day_count.to_f)

      out[pr.name] = percentage
    end

    out
  end

end
