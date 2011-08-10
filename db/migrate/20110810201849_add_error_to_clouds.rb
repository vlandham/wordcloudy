class AddErrorToClouds < ActiveRecord::Migration
  def self.up
    add_column :clouds, :error, :boolean, :default => false
  end

  def self.down
    remove_column :clouds, :error
  end
end
