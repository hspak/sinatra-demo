class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.string :title, unique: true
      t.integer :count, :default => 0
    end
  end

  def self.down
    drop_table :lists
  end
end
