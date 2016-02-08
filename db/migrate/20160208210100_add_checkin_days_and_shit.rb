class AddCheckinDaysAndShit < ActiveRecord::Migration
  def change
    change_table 'project_checkins' do |t|
      t.belongs_to :checkin_day
    end

    create_table 'checkin_days' do |t|
      t.belongs_to :user

      t.date :date
      t.float :day_weight, default: 1

      t.timestamps
    end
  end
end
