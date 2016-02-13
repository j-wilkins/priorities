class CheckinDay < ActiveRecord::Base
  belongs_to :user
  has_many :project_checkins

  def self.today(user)
    where(user: user, date: Date.today).first || begin
      create(user: user, date: Date.today)
    end
  end

  def self.yesterday(user)
    where(user: user, date: Date.today.prev_day).first || begin
      create(user: user, date: Date.today.prev_day)
    end
  end

  scope(:day_count, ->(user) { where(user: user).pluck(:day_weight).sum})
end
