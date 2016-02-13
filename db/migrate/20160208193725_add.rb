class Add < ActiveRecord::Migration
  def change
    change_table 'project_checkins' do |t|
      t.integer :day_weight
    end
  end
end
