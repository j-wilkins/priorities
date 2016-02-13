class StatsMessage
  def self.build(user)
    new(user).build
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def build
    if user.projects.enabled.count == 0
      return "You don't have any projects! Create one with '!project \"project name\""
    end
    day_count = CheckinDay.day_count(user)

    percentage_sums = user.project_checkins.group(:project_id).sum(:percentage)

    strings = user.projects.map do |pr|
      percentage = ((percentage_sums[pr.id] || 0) / day_count.to_f)

      " %.2f :  %s" % [percentage, pr.name]
    end

    "Heres your project percentage stats:\n#{strings.join("\n")}"
  end

end
