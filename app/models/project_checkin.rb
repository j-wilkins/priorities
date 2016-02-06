class ProjectCheckin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  scope(:today, -> { where(date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) })
end
