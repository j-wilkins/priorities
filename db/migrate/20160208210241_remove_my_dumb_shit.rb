class RemoveMyDumbShit < ActiveRecord::Migration
  def change
    remove_column :project_checkins, :date
    remove_column :project_checkins, :day_weight
  end
end
