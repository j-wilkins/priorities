class StatsGraph
  COLORS = %w|0392cf 7bc043 fdf498 f37736 ee4035 ffe28a 6fcb9f fb2e01 666547 f1cbff ffffff c9c9ff ffbdbd e1f7d5|
  def self.build(stats)
    new(stats).call
  end

  attr_reader :stats

  def initialize(stats); @stats = stats; end

  def call
    labels = stats.map {|k,v| "%s - %.2f" % [k, v]}
    colors = COLORS.take(labels.count)

    chart = GoogleImageCharts::PieChart.new({
      title: "Priority Stats", height: 500, width: 600,
      labels: labels, data: stats.values, colors: colors, additionalOptions: ''
    })
    chart.instance_variable_set(:@chartType, 'p3')
    chart.chart_url
  end
end
