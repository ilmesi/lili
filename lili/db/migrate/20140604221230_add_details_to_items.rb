class AddDetailsToItems < ActiveRecord::Migration
  def change
    add_column :items, :amount, :integer
    add_column :items, :cost, :decimal
    add_column :items, :size, :integer
  end
end
