class User < ActiveRecord::Base
  has_many :projects do
    def enabled
      where(enabled: true).order(name: :asc)
    end
  end
  has_many :project_checkins
end

