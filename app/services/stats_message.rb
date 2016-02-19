class StatsMessage
  def self.build(stats, builder = StatsBuilder)
    stats = builder.call(stats) if stats.is_a?(User)
    new(stats).build
  end

  attr_reader :stats

  def initialize(stats)
    @stats = stats
  end

  def build
    strings = stats.map do |name, percentage|
      " %.2f :  %s" % [percentage, name]
    end

    "Heres your project percentage stats:\n#{strings.join("\n")}"
  end

end
