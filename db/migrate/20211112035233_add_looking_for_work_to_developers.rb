class AddLookingForWorkToDevelopers < ActiveRecord::Migration[7.0]
  def up
    add_column :developers, :looking_for_work, :boolean, null: false, default: true

    Developer.where("available_on >= ?", Date.today + 1.year).update_all(looking_for_work: false)
  end

  def down
    remove_column :developers, :looking_for_work
  end
end
