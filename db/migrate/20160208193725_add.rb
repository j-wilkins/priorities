class Add < ActiveRecord::Migration
  def change
    change_table 'project_checkins' do |t|
      t.float :day_weight, default: 1
    end
  end
end
