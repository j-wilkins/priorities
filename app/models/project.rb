class Project < ActiveRecord::Base
  belongs_to :user
  has_many :checkins

  #scope(:enabled) { |user| where(enabled: true).order(name: :asc) }

  def enabled?
    enabled
  end

  def enable!
    !enabled && update_attribute(:enabled, true)
  end

  def disable!
    enabled && update_attribute(:enabled, false)
  end
end

