class ProjectCheckin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :checkin_day

  scope(:today, ->(date) { where(checkin_day: date) })
  scope(:today_for_project, ->(date, project) { today(date).where(project: project) })
end
