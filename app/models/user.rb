class User < ActiveRecord::Base
  has_many :projects do
    def enabled
      where(enabled: true).order(name: :asc)
    end
  end
  has_many :project_checkins

  def checkin_days
    project_checkins.pluck(:date).map {|d| d.beginning_of_day}.uniq.count
  end
end

