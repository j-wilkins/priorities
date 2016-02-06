class SetupTheWorld < ActiveRecord::Migration
  def change
    create_table "project_checkins" do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.datetime   :date
      t.integer    :percentage

      t.timestamps
    end

    create_table "projects" do |t|
      t.belongs_to :user
      t.string :name
      t.boolean :enabled

      t.timestamps
    end

    create_table "users" do |t|
      t.string :name
      t.string :phone_number
      t.string :password_hash

      t.timestamps
    end
  end
end
