class StatsMessage
  def self.build(user)
    new(user).build
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def build
    day_count = user.checkin_days
    max_name_length = user.projects.pluck(:name).map(&:length).max

    percentage_sums = user.project_checkins.group(:project_id).sum(:percentage)

    strings = user.projects.map do |pr|
      percentage = ((percentage_sums[pr.id] || 0) / day_count.to_f)

      "%-#{max_name_length}s %.2f" % ["#{pr.name}:", percentage]
    end

    "Heres your project percentage stats:\n#{strings.join("\n")}"
  end

end
