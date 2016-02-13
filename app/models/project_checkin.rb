class ProjectCheckin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :checkin_day

  scope(:on_day, ->(date) { where(checkin_day: date) })
  scope(:for_project_and_date, ->(project, date) { on_day(date).where(project: project) })
end
