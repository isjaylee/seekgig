class AddSearchableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :searchable, :boolean, default: false
  end
end
