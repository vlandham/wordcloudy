class AddPreviewedAtToClouds < ActiveRecord::Migration
  def self.up
    add_column :clouds, :previewed_at, :datetime
  end

  def self.down
    remove_column :clouds, :previewed_at
  end
end
